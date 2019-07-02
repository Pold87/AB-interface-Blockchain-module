#!/bin/bash
set -e
geth --datadir=~/.ethereum/devchain init "/root/files/genesis.json"
BOOTSTRAP_IP=`cat /root/shared/my_enode.enode | tr -d '"'`
GETH_OPTS=${@/XXX/$BOOTSTRAP_IP}
echo "$GETH_OPTS"
geth $GETH_OPTS&
sleep 7
bash /root/exec_template.sh "/root/templates/createAccount.txt"
bash /root/exec_template.sh "/root/templates/setEtherbase.txt"
bash /root/get_enode.sh
bash /root/exec_template.sh "/root/templates/unlockAccount.txt"
tail -f /dev/null
