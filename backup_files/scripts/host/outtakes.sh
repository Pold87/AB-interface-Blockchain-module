#solc --overwrite --abi --bin -o . $SCOUT

# Deploy contract (using template)
BINFILE=$(cat "Estimation.bin")
BINFILE="0x${BINFILE}"
ABIFILE=$(cat "Estimation.abi")
CONTRACTTEMPLATE="contractTemplate.txt"

sed -e "s|INTERFACE|${ABIFILE}|g" -e "s|DATA|${BINFILE}|g" ${CONTRACTTEMPLATE} > CONTRACT.txt
geth --exec "personal.unlockAccount(eth.coinbase, \"\", 0)"  attach ~/.ethereum/devchain/geth.ipc 
geth --exec "loadScript(\"CONTRACT.txt\")"  attach ~/.ethereum/devchain/geth.ipc > transaction_receipt.txt

