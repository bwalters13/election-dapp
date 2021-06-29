from brownie import Election, accounts


def main():
    """ Simple deploy script for our two contracts. """
  
    accounts[0].deploy(Election)
