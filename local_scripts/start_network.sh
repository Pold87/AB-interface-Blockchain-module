# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARgoS and start the experiments after the
# initialization phase has started

N=$1
DOCKERFOLDER="/home/vstrobel/Documents/docker-geth-network/"
# Start Ethereum network using Docker 

cd ${DOCKERFOLDER}
docker stack rm ethereum
sleep 20
docker stack deploy -c ./docker-compose.yml ethereum
docker service scale ethereum_eth=$N

rm ${DOCKERFOLDER}/geth/shared/*
rm ${DOCKERFOLDER}/geth/deployed_contract/*

sleep 20
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_template.sh "/root/templates/unlockAccount.txt"

# Start mining on bootstrap node

docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_cmd.sh "miner.start(1)"
CONTRACTBASE="smart_contract_threshold"

sleep 20

# Deploy contract and get contract address
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) node /root/mydeploy.js

#sleep 2
#docker-compose stop bootstrap
#docker service update --replicas 0 ethereum_bootstrap
