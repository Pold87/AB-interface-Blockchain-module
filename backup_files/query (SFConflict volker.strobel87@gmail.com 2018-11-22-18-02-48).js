const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

async function query() {
    let accounts = await web3.eth.getAccounts();
    let password = ''
    let confirmed = web3.eth.personal.unlockAccount(accounts[0], password, 0)
	.then((response) => {
		console.log(response);
	}).catch((error) => {
		console.log(error);
	});
    
    let code = fs.readFileSync('smart_contract_threshold.sol').toString();
    let compiledCode = solc.compile(code);
    // TODO: maybe better to read from fs
    let abi = JSON.parse(compiledCode.contracts[':Estimation'].interface);
    let contractAddress = fs.readFileSync('contractAddress.txt').toString();
    let votingContract = new web3.eth.Contract(abi, contractAddress);

    let result = await votingContract.methods.getMean().call({from: accounts[0]});
    console.log('result:', result); // 0

}

query()
//.then(() => console.log('Success'))
.catch(err => console.log('Script failed:', err));
