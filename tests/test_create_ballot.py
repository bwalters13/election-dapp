import pytest
from brownie import Election, accounts

@pytest.fixture(scope="module")
def election():
    return accounts[0].deploy(Election)

@pytest.fixture
def add_ballot(election):
    election.createBallot([], {'from': accounts[0]})

def test_vote(election):
    election.createBallot([], {'from': accounts[0]})
    assert election.ballots(0)

def test_add_candidate(election):
    election.createBallot([], {'from': accounts[0]})
    election.addCandidate("Blake", 0, {'from': accounts[0]})
    assert len(election.getCandidates(0)) == 1