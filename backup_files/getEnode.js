const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const Web3ipc = require('web3-ipc');

var host = '/root/.ethereum/devchain/geth.ipc'
var web3ipc = new Web3ipc(host);

var callback = (err, result) => {console.log(err ? err : result)}


web3-ipc.admin.datadir(callback);  // /home/momo/.ethereum

async function getEnode() {
  let nodeInfo = web3.personal;
  console.log(web3.admin.addPeer("yeaty"));
}

getEnode()
.then(() => console.log('Success'))
.catch(err => console.log('Script failed:', err));

