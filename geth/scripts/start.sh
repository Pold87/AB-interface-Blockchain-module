#!/bin/bash
set -e
sleep 12
geth --datadir=~/.ethereum/devchain init "/root/files/genesis_poa.json"
BOOTSTRAP_IP=`cat /root/shared/my_enode.enode | tr -d '"'`
GETH_OPTS=${@/XXX/$BOOTSTRAP_IP}
echo "$GETH_OPTS"
geth $GETH_OPTS&
sleep 13
bash /root/exec_template.sh "/root/templates/createAccount.txt"
sleep 1
bash /root/exec_template.sh "/root/templates/setEtherbase.txt"
sleep 1
bash /root/get_enode.sh
sleep 1
bash /root/exec_template.sh "/root/templates/unlockAccount.txt"
sleep 1
tail -f /dev/null
