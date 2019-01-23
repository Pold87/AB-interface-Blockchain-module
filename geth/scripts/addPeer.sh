echo "Im in addPeer.sh"
echo $1
geth --exec "admin.addPeer(\"$1\")" attach ~/.ethereum/devchain/geth.ipc 
