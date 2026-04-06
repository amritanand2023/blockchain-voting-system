pipeline {
    agent any

    tools {
        maven 'M3'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: '<your-repo-url>'
            }
        }

        stage('Build & Test') {
            steps {
                bat 'mvn clean test'
            }
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting {
    address public admin;
    bool public electionStarted;
    bool public electionEnded;
    uint public candidatesCount;
    uint public totalVotes;
    struct Candidate {
        uint id;
        string name;
        string crimeHistory;
        string netWorth;
        uint voteCount;
        bool active;
    }
    struct Voter {
        bool hasVoted;
    }
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    event ElectionStarted(uint time);
    event ElectionEnded(uint time);
    event CandidateAdded(uint id, string name);
    event CandidateRemoved(uint id);
    event VoteCast(bytes32 voteHash);
    constructor() {
        admin = msg.sender;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }
    function startElection() public onlyAdmin {
        require(!electionStarted, "Already started");
        electionStarted = true;
        electionEnded = false;
        emit ElectionStarted(block.timestamp);
    }
    function endElection() public onlyAdmin {
        require(electionStarted, "Not started");
        electionEnded = true;
        emit ElectionEnded(block.timestamp);
    }
    function addCandidate(
        string memory _name,
        string memory _crimeHistory,
        string memory _netWorth
    ) public onlyAdmin {
        require(!electionStarted, "Election already started");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _name,
            _crimeHistory,
            _netWorth,
            0,
            true
        );
        emit CandidateAdded(candidatesCount, _name);
    }
    function removeCandidate(uint _id) public onlyAdmin {
        require(!electionStarted, "Election already started");
        require(candidates[_id].active, "Already removed");
        candidates[_id].active = false;
        emit CandidateRemoved(_id);
    }
    function vote(uint _candidateId) public {
        require(electionStarted, "Election not started");
        require(!electionEnded, "Election ended");
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(candidates[_candidateId].active, "Invalid candidate");

        voters[msg.sender].hasVoted = true;
        candidates[_candidateId].voteCount++;
        totalVotes++;
        bytes32 receipt = keccak256(
            abi.encodePacked(msg.sender, block.timestamp, totalVotes)
        );
        emit VoteCast(receipt);
    }
    function getElectionStatus() public view returns (string memory) {
        if (!electionStarted) return "Not Started";
        if (electionEnded) return "Ended";
        return "Ongoing";
    }
}



































🚀 ✅ STEP-BY-STEP (FOLLOW EXACTLY)
________________________________________
🟢 STEP 1: Create Project Folder
👉 On Desktop:
simple-maven-app
________________________________________
🟢 STEP 2: Create Folder Structure (IMPORTANT)
Inside it create:
simple-maven-app
 └── src
     ├── main/java/com/example
     └── test/java/com/example
________________________________________
🟢 STEP 3: Create App.java
📄 Path:
src/main/java/com/example/App.java
👉 Paste:
package com.example;

public class App {
    public int add(int a, int b) {
        return a + b;
    }
}
________________________________________
🟢 STEP 4: Create AppTest.java
📄 Path:
src/test/java/com/example/AppTest.java
👉 Paste:
package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

public class AppTest {
    @Test
    public void testAdd() {
        App app = new App();
        assertEquals(5, app.add(2, 3));
    }
}
________________________________________
🟢 STEP 5: Create pom.xml
📄 Path:
simple-maven-app/pom.xml
👉 Paste:
<project xmlns="http://maven.apache.org/POM/4.0.0"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
 http://maven.apache.org/xsd/maven-4.0.0.xsd">

 <modelVersion>4.0.0</modelVersion>
 <groupId>com.example</groupId>
 <artifactId>simple-maven-app</artifactId>
 <version>1.0-SNAPSHOT</version>

 <dependencies>
  <dependency>
   <groupId>junit</groupId>
   <artifactId>junit</artifactId>
   <version>4.13.2</version>
   <scope>test</scope>
  </dependency>
 </dependencies>

</project>
________________________________________
🟢 STEP 6: Test Locally
👉 Open terminal inside folder:
mvn clean test
✔ You must see:
BUILD SUCCESS
________________________________________
🟢 STEP 7: Push to GitHub
👉 Run:
git init
git add .
git commit -m "Maven project"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
________________________________________
🟢 STEP 8: Install Maven (if not done)
👉 Download Maven → extract
Set:
MAVEN_HOME = C:\Program Files\Apache\apache-maven
Add to PATH:
%MAVEN_HOME%\bin
👉 Check:
mvn -version
________________________________________
🟢 STEP 9: Configure Maven in Jenkins
👉 Go to:
Manage Jenkins → Tools → Maven Installations
Fill:
•	Name: M3 
•	MAVEN_HOME: your path 
•	Uncheck auto install 
👉 Save
________________________________________
🟢 STEP 10: Create Pipeline Job
👉 Jenkins → New Item
Name:
maven-pipeline
Select:
✔ Pipeline → OK
________________________________________
🟢 STEP 11: Add Pipeline Script
👉 Paste:
pipeline {
    agent any

    tools {
        maven 'M3'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: '<your-repo-url>'
            }
        }

        stage('Build & Test') {
            steps {
                bat 'mvn clean test'
            }
        }
    }
}
________________________________________
🟢 STEP 12: Run Pipeline
👉 Click:
Build Now
________________________________________
🟢 STEP 13: Check Output
👉 Console Output:
✔ Shows:
BUILD SUCCESS
Finished: SUCCESS











🟢 METHOD 1: Install Automatically (BEST)
👉 Use when option works in Jenkins
🔹 Steps:
1.	Open Jenkins 
2.	Go to: 
Manage Jenkins → Tools
3.	Scroll to: 
Maven Installations
4.	Click: 
Add Maven
5.	Fill: 
•	Name: 
M3
•	✔ Tick: 
Install automatically
•	Select version (latest) 
6.	Click Save 
________________________________________
🎯 Result:
✔ Jenkins downloads Maven
✔ No manual setup needed
________________________________________
❌ If NOT WORKING → Use Method 2
________________________________________
🔧 🟢 METHOD 2: Manual Maven Installation
________________________________________
🟢 STEP 1: Download Maven
👉 Download Apache Maven (zip)
________________________________________
🟢 STEP 2: Extract
👉 Extract to:
C:\apache-maven-3.9.6
________________________________________
🟢 STEP 3: Set Environment Variables
👉 Open System Environment Variables
Add:
MAVEN_HOME = C:\apache-maven-3.9.6
Edit PATH:
%MAVEN_HOME%\bin
________________________________________
🟢 STEP 4: Verify
mvn -version
✔ Should show Maven version
________________________________________
🟢 STEP 5: Configure in Jenkins
👉 Go:
Manage Jenkins → Tools
👉 Maven Installations:
•	Name: 
M3
•	❌ Uncheck auto install 
•	MAVEN_HOME: 
C:\apache-maven-3.9.6
👉 Save

