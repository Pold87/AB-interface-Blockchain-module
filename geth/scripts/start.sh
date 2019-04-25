#!/bin/bash
set -e
#cd /root/eth-net-intelligence-api
#perl -pi -e "s/XXX/$(hostname)/g" app.json
#pm2 start ./app.json
#sleep 3
geth --datadir=~/.ethereum/devchain init "/root/files/genesis.json"
sleep 3
BOOTSTRAP_IP=`cat /root/shared/my_enode.enode | tr -d '"'`
GETH_OPTS=${@/XXX/$BOOTSTRAP_IP}
echo "$GETH_OPTS"
geth $GETH_OPTS&
sleep 7
bash /root/get_enode.sh
bash /root/exec_template.sh "/root/templates/unlockAccount.txt"
tail -f /dev/null
