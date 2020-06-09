pragma solidity ^0.4.0;
contract Estimation {

int public mean;
int public count;
int public threshold = 100000;
int public m2;

event consensusReached(uint c);

 function sqrt(int x) constant  returns (int y) {
   int z = (x + 1) / 2;
   y = x;
   while (z < y) {
     y = z;
     z = (x / z + z) / 2;
   }
 }

 function vote() payable {
   count = count + 1;
   int delta = int(msg.value) - mean;
   mean = mean + delta / count;
   int delta2 = int(msg.value) - mean;
   m2 = m2 + delta * delta2;

   // Handle consensus
   if (count < 2) {
     consensusReached(1);
   } else {

    int myvar = m2 / (count - 1);
    int acc = myvar / count;
    int se = sqrt(acc);

    if (se < threshold && count > 10) {
        consensusReached(2);
      } else {
        consensusReached(1);
      }
    }
 }

 function getMean() constant returns (int) {
   return mean;
 }

 function getCount() constant returns (int) {
   return count;
 }

 function calcSE() constant returns (int) {
  int myvar = m2 / (count - 1);
  int acc = myvar / count;
  int se = sqrt(acc);

  return se;
 }

 function checkStop() constant returns (int) {

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
