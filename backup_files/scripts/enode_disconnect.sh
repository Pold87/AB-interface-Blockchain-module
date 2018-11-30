enode=`geth --exec "admin.removePeer($1)"  attach ~/.ethereum/devchain/geth.ipc`

void removePeer() {

    exec("bash enode_disconnect.sh");
    
}

