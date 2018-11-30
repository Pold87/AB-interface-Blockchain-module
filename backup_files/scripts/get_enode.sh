enode=`geth --exec "admin.nodeInfo.enode"  attach ~/.ethereum/devchain/geth.ipc`
ip=`hostname -i`
enode=${enode/\[::\]/${ip}}
echo $enode > my_enode.enode


