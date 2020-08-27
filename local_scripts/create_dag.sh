# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARGoS and start the experiments after the
# initialization phase has started

# Change to this script's folder
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

. ../global_config.sh

# Start Ethereum network using Docker 

cd ${DOCKERFOLDER}
docker stack rm ethereum

rm -f ${DOCKERFOLDER}/geth/shared/my_enode.enode
rm -f ${DOCKERFOLDER}/geth/deployed_contract/*

docker stack deploy -c ./docker-compose.yml ethereum

sleep 7
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) geth makedag 0 /root/.ethash/
docker exec -it $(docker ps -q -f name=ethereum_bootstrap.1) geth makedag 30000 /root/.ethash/
