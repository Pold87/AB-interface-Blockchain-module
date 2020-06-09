BINFILE=$(cat "/Estimation.bin")
BINFILE="0x${BINFILE}"
ABIFILE=$(cat "/Estimation.abi")
CONTRACTTEMPLATE="/root/scripts/contractTemplate.txt"

sed -e "s|INTERFACE|${ABIFILE}|g" -e "s|DATA|${BINFILE}|g" ${CONTRACTTEMPLATE} > CONTRACT.txt

geth --exec "personal.unlockAccount(eth.coinbase, \"\", 0)"  attach ~/.ethereum/devchain/geth.ipc 
geth --exec "loadScript(\"CONTRACT.txt\")"  attach ~/.ethereum/devchain/geth.ipc > transaction_receipt.txt
