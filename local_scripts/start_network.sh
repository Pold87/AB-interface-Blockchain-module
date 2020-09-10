# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARGoS and start the experiments after the
# initialization phase has started

# Change to this script's folder
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

N=$1

source global_config_blockchain.sh
source ${ARGOSFOLDER}/global_config.sh

# Start Ethereum network using Docker 

cd ${DOCKERBASE}
docker stack rm ethereum

echo "I am in this folder now:"
echo `pwd`

rm -f ${DOCKERBASE}/geth/shared/my_enode.enode
rm -f ${DOCKERBASE}/geth/deployed_contract/*

docker stack deploy -c ./docker-compose.yml ethereum
docker service scale ethereum_eth=$N

sleep 7
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_template.sh "/root/templates/unlockAccount.txt"

# Start mining on bootstrap node

docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_cmd.sh "miner.start(1)"
CONTRACTBASE="Estimation"

sleep 7

# Deploy contract and get contract address
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) node /root/mydeploy.js
