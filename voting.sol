
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






