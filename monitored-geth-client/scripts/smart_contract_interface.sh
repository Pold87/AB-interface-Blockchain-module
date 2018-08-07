interface=$1
contractAddress=$2
func=$3
args=$4
value=$5

"var cC = web3.eth.contract(${interface});var c = cC.at(${contractAddress});c.${func}({value: ${value}, from: eth.coinbase, gas: '3000000'});";





