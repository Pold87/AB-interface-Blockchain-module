# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARgoS and start the experiments after the
# initialization phase has started

N=$1
DOCKERFOLDER="/home/volker/Documents/mygithub-software/ethereum-docker/"
# Start Ethereum network using Docker 

#cd ${DOCKERFOLDER} && docker-compose down
#cd ${DOCKERFOLDER} && docker-compose up -d --scale eth=$N

cd ${DOCKERFOLDER}
docker swarm leave --force
docker swarm init
docker stack rm ethereum
sleep 20
docker stack deploy -c ./docker-compose.yml ethereum
docker service scale ethereum_eth=$N

# Wait until everything is initialized
# TODO: find the right amount of time 
# TODO: replace with something better (signal that is fired as soon as geth is initialized)
sleep 20

# Start mining on bootstrap node
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) bash /root/exec_cmd.sh "miner.start(1)"

CONTRACTBASE="smart_contract_threshold"

# Deploy contract and get contract address
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) node /root/mydeploy.js

sleep 2
#docker-compose stop bootstrap
docker service update --replicas 0 ethereum_bootstrap
