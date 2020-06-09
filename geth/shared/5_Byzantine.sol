pragma solidity ^0.4.0;
contract Estimation {

int public mean = 5000000;
int public count = 0;
int public threshold = 140000;
int public m2;
int public numCurrentVotes = 0;
int public NEEDEDVOTES = 20;
uint public localCount = 0;
uint public weightCount = 0;
uint public voteCount = 0;
uint public outliers = 6;
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
votingInformation[] ripedVotes;
votingInformation[] youngVotes;
votingInformation[] newVotes;
mapping(address => int) public payoutForAddress;
mapping(address => int256) public weights;
event consensusReached(uint c);

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


function sortVotes() internal {
  if (allVotes.length == 0)
    return;
  quickSort(allVotes, 0, allVotes.length - 1);
    }
 
function quickSort(votingInformation[] storage arr, uint left, uint right) internal {
   uint i = left;
   uint j = right;
   int256 pivot = arr[left + (right - left) / 2].diff;
   while (i <= j) {
            while (arr[i].diff < pivot) i++;
            while (pivot < arr[j].diff) j--;
            if (i <= j) {
                (arr[i], arr[j]) = (arr[j], arr[i]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }


function askForPayout() public {

  uint payoutFactor = allVotes.length / (allVotes.length - outliers);

  if (allVotes.length > 20) {
    
    address r;    

    int256 miniMean = 0;
    int256 miniCount = 0;

    for (uint c = 0; c < allVotes.length; c++) {
      miniCount += 1;
      miniMean += (allVotes[c].quality - miniMean) / miniCount;
    }

    for (uint b = 0; b < allVotes.length; b++) {
      allVotes[b].diff = abs(miniMean - allVotes[b].quality);
    }

    sortVotes();

    for (uint a = 0; a < allVotes.length / 2; a++) {
        
	weightCount += 1;      

        // Get sender of that message
        r = allVotes[a].robot;
        
        localCount = localCount + 1;	
 	int256 delta = allVotes[a].quality - mean;
        int256 absDelta = abs(delta);
	int256 w_n = 1;
	W_n = W_n + w_n;
	mean += (w_n * delta) / W_n;
	count = count + 1;
	
	r.transfer(9.0 ether * payoutFactor);
        
        // If weights[r] < 0, the vote gets ignored

    }

   delete allVotes;

  }
 }

function getSenderBalance() public view returns (uint) {
    return msg.sender.balance;
}

 function vote(int x_n) public payable {

   if (msg.value < 10 ether) {
       revert();
   }

   int weight = int(msg.sender.balance);

   voteCount += 1;  

   //int diff = x_n - mean;
   //diff = abs(diff);

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

 function calcSE() public view returns (int) {
  int myvar = m2 / (count - 1);
  int acc = myvar / count;
  int se = sqrt(acc);

  return se;
 }

 function checkStop() public view returns (int) {

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
