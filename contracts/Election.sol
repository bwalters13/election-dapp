pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

contract Election {
    struct Candidate {
	    uint id;
        string name;
	    uint voteCount;
    }

    struct Ballot {
        uint id;
        uint deadline;
        Candidate[] choices;
        uint candidatesCount;
    }

    event Vote(address indexed _from, uint indexed _ballotId, uint indexed _candidateId);
    
    uint public nextBallotId;

    mapping(uint => Ballot) public ballots;

    function createBallot(string[] memory _choices) public {
        ballots[nextBallotId].id = nextBallotId;
        ballots[nextBallotId].deadline = now + 1 days;
        for(uint i = 0; i < _choices.length; i++) {
            ballots[nextBallotId].choices.push(Candidate(i, _choices[i], 0));
        }
        ballots[nextBallotId].candidatesCount = _choices.length;
        nextBallotId++;
    }

    function addCandidate(string memory _name, uint ballotId) public ballotExists(ballotId) {
        ballots[ballotId].choices.push(Candidate(ballots[ballotId].candidatesCount, _name, 0));
        ballots[ballotId].candidatesCount++;
    }

    function vote(uint ballotId, uint candidateId) public ballotExists(ballotId) votingActive(ballotId) {
	    ballots[ballotId].choices[candidateId].voteCount++;
        emit Vote(msg.sender, ballotId, candidateId);
    }

    function getVoteTotal(uint ballotId, uint candidateId) public view ballotExists(ballotId) returns (uint) {
        require(candidateId < ballots[ballotId].candidatesCount,"Candidate doesnt exist");
        return ballots[ballotId].choices[candidateId].voteCount;
    }

    function getCandidates(uint ballotId) public view ballotExists(ballotId) returns(Candidate[] memory) {
        return ballots[ballotId].choices;
    }

    modifier ballotExists(uint ballotId) {
        require(ballotId < nextBallotId, "Ballot doesn't exist");
        _;
    }
    
    modifier votingActive(uint ballotId) {
        require(ballots[ballotId].deadline > now, "Voting has ended");
        _;
    }

}
