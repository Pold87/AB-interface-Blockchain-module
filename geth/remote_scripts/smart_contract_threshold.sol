pragma solidity ^0.4.0;
contract Estimation {

int public mean = 5000000;
int public count = 0;
int public threshold = 140000;
int public m2;
int public numCurrentVotes = 0;
int public NEEDEDVOTES = 20;
uint public localCount = 0;
int W_n = 0;

struct votingInformation {
    address robot;
    int quality;
    uint blockNumber;
    uint weight;
    uint money;
  int diff;
  }

votingInformation[] allVotes;
votingInformation[] ripedVotes;
votingInformation[] youngVotes;
votingInformation[] newVotes;
mapping(address => int) public payoutForAddress;

event consensusReached(uint c);

function abs(int x) internal pure returns (int y) {
    if (x < 0) {
      return -x;
    } else {
      return x;
    }
  }

function getBalance() public constant returns (uint) {
    return address(this).balance;
}

function getBlockNumber() public constant returns (uint) {
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

    if (localCount < 10) {
        revert();
    }

    uint totalPayout = 0;

    /* Find out which votes are old enough */
    int totalVotesToConsider = 0;
    for (uint a = 0; a < allVotes.length; a++) {
        if (allVotes[a].blockNumber < block.number - 5) {
            totalVotesToConsider += 1;
	    allVotes[a].diff = abs(mean - allVotes[a].quality);
            ripedVotes.push(allVotes[a]);
            totalPayout += allVotes[a].money;
    } else {
            youngVotes.push(allVotes[a]);
        }
    }

    /* Sort riped votes  */
    for (uint i = 0; i < ripedVotes.length; i++){
        votingInformation memory vi = ripedVotes[i];
        uint j = i;

        while (j > 0 && ripedVotes[j-1].diff > vi.diff) {
            ripedVotes[j] = ripedVotes[j - 1];
            j -= 1;
        }
        ripedVotes[j] = vi;
    }

  uint payoutPerRobot;
  if (totalPayout == 0) {
    payoutPerRobot = 0;
  } else if (totalVotesToConsider == 1) {
    payoutPerRobot = totalPayout - 10000000;
  } else {
    payoutPerRobot = (totalPayout - 10000000) / (ripedVotes.length / 2);
  }

    if (totalPayout > 0) {
      for (uint z = 0; z < ripedVotes.length / 2; z++) {

	int delta = ripedVotes[z].quality - mean;
	int w_n = int(ripedVotes[z].weight);
	W_n = W_n + w_n;
	mean = mean + (w_n * delta) / W_n;
	count = count + 1;

	
	//	count = count + 1;
	//mean += (delta / count);
	ripedVotes[z].robot.send(payoutPerRobot);
      }
    }
   delete ripedVotes;

   delete allVotes;

   for (uint h = 0; h < youngVotes.length; h++) {
     allVotes.push(youngVotes[h]);
   }

   localCount = youngVotes.length;
   
   delete youngVotes;


 }


function getSenderBalance() public constant returns (uint) {
    return msg.sender.balance;
}

 function vote(int x_n) public payable {

    if (msg.value < 4 ether)
        revert();

    localCount = localCount + 1;	

   votingInformation memory vi = votingInformation(msg.sender, x_n, block.number, msg.sender.balance, msg.value, 0);

   allVotes.push(vi);

 }

 function getMean() public constant returns (int) {
   return mean;
 }

 function getCount() public constant returns (int) {
   return count;
 }

 function calcSE() public constant returns (int) {
  int myvar = m2 / (count - 1);
  int acc = myvar / count;
  int se = sqrt(acc);

  return se;
 }

 function checkStop() public constant returns (int) {

   if (count < 2) {
     return 2;
   }

   int myvar = m2 / (count - 1);
   int acc = myvar / count;
   int se = sqrt(acc);

   if (se < threshold) {
     return 1;
   } else {
     return 2;
   }
 }
}
