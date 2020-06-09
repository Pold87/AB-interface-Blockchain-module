const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8546"));

async function query() {
    let accounts = await web3.eth.getAccounts();
    let password = 'test'
    let confirmed = web3.eth.personal.unlockAccount(accounts[0], password, 600)
	.then((response) => {
		console.log(response);
	}).catch((error) => {
		console.log(error);
	});
    
    let code = fs.readFileSync('Voting.sol').toString();
    let compiledCode = solc.compile(code);
    let abi = JSON.parse(compiledCode.contracts[':Voting'].interface);    
    let votingContract = new web3.eth.Contract(abi, '0xcC6D161e8934053392424735dE3378d2F44A5669');

    let rama = web3.utils.asciiToHex('Rama');
    let result = await votingContract.methods.totalVotesFor(rama).call({from: accounts[0]});
    console.log('result:', result); // 0

    let receipt = await votingContract.methods.voteForCandidate(rama).send({from: accounts[0]});
    console.log('voteForCandidate receipt:', receipt);

    result = await votingContract.methods.totalVotesFor(rama).call({from: accounts[0]});
    console.log('new result:', result); // 1
}

query()
.then(() => console.log('Success'))
.catch(err => console.log('Script failed:', err));
