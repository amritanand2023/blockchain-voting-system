from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import base64
import numpy as np
import os

app = Flask(__name__)
CORS(app)

# Folder storing employee face data
DB_PATH = "faces"

# Load face detector
face_cascade = cv2.CascadeClassifier(
    cv2.data.haarcascades + 'haarcascade_frontalface_default.xml'
)

# Decode base64 image
def decode_image(b64):
    data = base64.b64decode(b64.split(",")[1])
    np_arr = np.frombuffer(data, np.uint8)
    return cv2.imdecode(np_arr, cv2.IMREAD_GRAYSCALE)

# Extract face region
def get_face(img):
    faces = face_cascade.detectMultiScale(img, 1.3, 5)
    if len(faces) == 0:
        return None
    x, y, w, h = faces[0]
    return img[y:y+h, x:x+w]

# -------------------------------
# VERIFY EMPLOYEE IDENTITY
# -------------------------------
@app.route("/verify", methods=["POST"])
def verify():
    data = request.json
    employee_id = data["aadhaar"]   # keep frontend same OR change later
    image = data["image"]

    stored_path = f"{DB_PATH}/{employee_id}/face.jpg"

    # Check if employee exists
    if not os.path.exists(stored_path):
        return jsonify({"success": False, "error": "Employee not found"})

    live = decode_image(image)
    stored = cv2.imread(stored_path, cv2.IMREAD_GRAYSCALE)

    # Extract face only
    live_face = get_face(live)
    stored_face = get_face(stored)

    if live_face is None or stored_face is None:
        return jsonify({"success": False, "error": "Face not detected"})

    # Resize
    live_face = cv2.resize(live_face, (200, 200))
    stored_face = cv2.resize(stored_face, (200, 200))

    # Normalize lighting
    live_face = cv2.equalizeHist(live_face)
    stored_face = cv2.equalizeHist(stored_face)

    # Compare faces
    diff = cv2.absdiff(live_face, stored_face)
    score = np.mean(diff)

    print("MATCH SCORE:", score)

    # Threshold (adjust if needed)
    if score < 50:
        return jsonify({
            "success": True,
            "score": float(score)
        })
    else:
        return jsonify({
            "success": False,
            "score": float(score)
        })

# -------------------------------
# RUN SERVER
# -------------------------------
if __name__ == "__main__":
    app.run(port=5000, debug=True)