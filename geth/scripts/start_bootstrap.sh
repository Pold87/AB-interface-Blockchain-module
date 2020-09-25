#!/bin/bash
set -e
#cd /root/eth-net-intelligence-api
#perl -pi -e "s/XXX/$(hostname)/g" app.json
#pm2 start ./app.json
#sleep 3
ip=`hostname -i`
echo $ip > /root/shared/my_enode.enode
geth --datadir=~/.ethereum/devchain init "/root/files/genesis_poa.json"
sleep 7
BOOTSTRAP_IP=`getent hosts bootstrap | cut -d" " -f1`
GETH_OPTS=${@/XXX/$BOOTSTRAP_IP}
geth $GETH_OPTS&
sleep 5
bash /root/get_enode.sh
#cp /root/my_enode.enode /root/shared/my_enode.enode
bash /root/exec_template.sh "/root/templates/unlockAccount.txt"
tail -f /dev/null
