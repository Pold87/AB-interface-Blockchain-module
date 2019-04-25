pragma solidity ^0.4.0;
contract Estimation {

uint public localCount = 0;
int public mean = 50;

function vote(int x_n) public payable {

    localCount = localCount + 1;	
 }

function getMean() public view returns (int) {
   return mean;
 }
}
