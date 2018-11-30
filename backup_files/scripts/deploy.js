const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://172.20.0.6:8545"));


async function deploy() {
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
    let bytecode = compiledCode.contracts[':Voting'].bytecode;
    let votingContract = new web3.eth.Contract(abi, {from: accounts[0], gas: 47000, data: '0x' + bytecode});

    let rama = web3.utils.asciiToHex('Rama');
    let nick = web3.utils.asciiToHex('Nick');
    let jose = web3.utils.asciiToHex('Jose');

    let contractInstance = await votingContract.deploy({
        arguments: [[rama, nick, jose]]
    })
    .send({
        from: accounts[0],
        gas: 1500000
    }, (err, txHash) => {
        console.log('send:', err, txHash);
    })
    .on('error', (err) => {
        console.log('error:', err);
    })
    .on('transactionHash', (err) => {
        console.log('transactionHash:', err);
    })
    .on('receipt', (receipt) => {
        console.log('receipt:', receipt);
        votingContract.options.address = receipt.contractAddress;
    });

    console.log('contractInstance.options:', contractInstance.options);

    let result = await votingContract.methods.totalVotesFor(rama).call({from: accounts[0]});
    console.log('result:', result); // 0

    let receipt = await votingContract.methods.voteForCandidate(rama).send({from: accounts[0]});
    console.log('voteForCandidate receipt:', receipt);

    result = await votingContract.methods.totalVotesFor(rama).call({from: accounts[0]});
    console.log('new result:', result); // 1
}

deploy()
.then(() => console.log('Success'))
.catch(err => console.log('Script failed:', err));
