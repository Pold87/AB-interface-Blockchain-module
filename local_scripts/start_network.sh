# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARgoS and start the experiments after the
# initialization phase has started

N=$1
DOCKERFOLDER="/home/vstrobel/Documents/docker-geth-network/"
# Start Ethereum network using Docker 

cd ${DOCKERFOLDER}
docker stack rm ethereum

rm -f ${DOCKERFOLDER}/geth/shared/my_enode.enode
rm -f ${DOCKERFOLDER}/geth/deployed_contract/*

docker stack deploy -c ./docker-compose.yml ethereum
docker service scale ethereum_eth=$N

sleep 7
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_template.sh "/root/templates/unlockAccount.txt"

# Start mining on bootstrap node

docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_cmd.sh "miner.start(1)"
CONTRACTBASE="smart_contract_threshold"

sleep 7

# Deploy contract and get contract address
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) node /root/mydeploy.js
