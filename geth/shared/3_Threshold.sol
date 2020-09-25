pragma solidity ^0.4.0;
contract Estimation {

int public mean = 5000000;
int public count = 0;
int public threshold = 140000;
int public roundthreshold = 2000000;
int public m2;
uint public ticketPrice = 40;
int public round;
int public numCurrentVotes = 0;
int public NEEDEDVOTES = 20;
uint public localCount = 0;
uint public weightCount = 0;
uint public voteCount = 0;
uint public outliers = 6;
int public tau = 1000000;
uint public consensusReached = 0;
 
int256 W_n = 0;

struct votingInformation {
    address robot;
    int256 quality;
    uint blockNumber;
    int weight;
    uint money;
    int diff;
  }

votingInformation[] allVotes;
address[] public robotsToPay;
mapping(address => int) public payoutForAddress;
mapping(address => int256) public weights;

function abs(int x) internal pure returns (int y) {
    if (x < 0) {
      return -x;
    } else {
      return x;
    }
  }

function getBalance() public view returns (uint) {
    return address(this).balance;
}

function getBlockNumber() public view returns (uint) {
    return block.number;
}

 function sqrt(int x) internal pure returns (int y) {
   int z = (x + 1) / 2;
   y = x;
   while (z < y) {
     y = z;
     z = (x / z + z) / 2;
   }
 }

function askForPayout() public {

  if (allVotes.length == 20) {

    address r;

    int oldMean = mean;    

    for (uint a = 0; a < allVotes.length; a++) {

      int256 delta = allVotes[a].quality - mean;

      if (round == 0 || abs(delta) < roundthreshold) {

    weightCount = weightCount + 1;

        // Get sender of that message
        r = allVotes[a].robot;

    robotsToPay.push(r);

        localCount = localCount + 1;

    int256 w_n = 1;
    W_n = W_n + w_n;
    mean += (w_n * delta) / W_n;
    count = count + 1;

      }
    }

    // Reimburse robots

    uint payoutFactor = allVotes.length / robotsToPay.length;
    for (uint b = 0; b < robotsToPay.length; b++) {
      robotsToPay[b].transfer((ticketPrice - 1) * 1 ether * payoutFactor);
    }

    round = round + 1;
    delete allVotes;
    delete robotsToPay;

    // Determine consensus
    if (consensusReached == 2 || ((abs(oldMean - mean) < tau) && localCount > 39)) {
      consensusReached = 2;
    } else {
      consensusReached = 1;
    }
  }    
}

function getSenderBalance() public view returns (uint) {
    return msg.sender.balance;
}

 function vote(int x_n) public payable {

   if (msg.value < ticketPrice * 1 ether) {
       revert();
   }

   askForPayout();

   int weight = int(msg.sender.balance);

   voteCount += 1;

   votingInformation memory vi = votingInformation(msg.sender, x_n, block.number, weight, msg.value, 0);

   allVotes.push(vi);

 }

 function getMean() public view returns (int) {
   return mean;
 }

 function getCount() public view returns (int) {
   return count;
 }

 function getWeight() public view returns (int256) {
  return weights[msg.sender];
}

}

