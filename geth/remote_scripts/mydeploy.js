const fs = require('fs');
const solc = require('solc');
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

async function deploy() {
    let accounts = await web3.eth.getAccounts();
    let password = '';
    let confirmed = web3.eth.personal.unlockAccount(accounts[0], password, 0)
	.then((response) => {
		console.log(response);
	}).catch((error) => {
		console.log(error);
	});
    
    let code = fs.readFileSync('/root/smart_contract_threshold.sol').toString();
    let compiledCode = solc.compile(code);
    let abi = JSON.parse(compiledCode.contracts[':Estimation'].interface);    
    fs.writeFile("/root/Estimation.abi", compiledCode.contracts[':Estimation'].interface);
    let bytecode = compiledCode.contracts[':Estimation'].bytecode;
    fs.writeFile("/root/Estimation.bin", bytecode);
    let votingContract = new web3.eth.Contract(abi, {from: accounts[0], gas: 47000, data: '0x' + bytecode});

    let contractInstance = await votingContract.deploy({})
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
        fs.writeFile("/root/contractAddress.txt", receipt.contractAddress);
    });

    console.log('contractInstance.options:', contractInstance.options);
}

deploy()
.then(() => console.log('Success'))
.catch(err => console.log('Script failed:', err));
