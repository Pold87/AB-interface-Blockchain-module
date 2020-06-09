txhash=$1
interface=`cat /Estimation.abi`
contractAddress=`bash get_contract_address.txt $txhash`
func=$3
args=$4
value=$5

"var cC = web3.eth.contract(${interface});var c = cC.at(${contractAddress});c.vote(60, {value: 100, from: eth.coinbase, gas: '3000000'});";




