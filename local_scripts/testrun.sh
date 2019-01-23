# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARgoS and start the experiments after the
# initialization phase has started

N=4
DOCKERFOLDER="/home/volker/Documents/mygithub-software/ethereum-docker/"
# Start Ethereum network using Docker 

cd ${DOCKERFOLDER} && sudo docker-compose down
cd ${DOCKERFOLDER} && sudo docker-compose up -d --scale eth=$N

# Wait until everything is initialized
# TODO: find the right amount of time 
# TODO: replace with something better (signal that is fired as soon as geth is initialized)
sleep 10

CONTRACTBASE="smart_contract_threshold"

# Unlock account of bootstrap node
#sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/unlockAccount.txt")'

# Start mining on bootstrap node
#sudo docker exec -it bootstrap bash /root/exec_cmd.sh "miner.start(1)"

# Deploy contract and get contract address
sudo docker exec -it bootstrap node /root/mydeploy.js

# Copy ABI
sudo docker cp bootstrap:/root/Estimation.abi .

# Copy account address
sudo docker cp bootstrap:/root/contractAddress.txt .

cat contractAddress.txt

# Call interface for localcount
INTERFACE=`cat Estimation.abi`
ADDRESS=$(cat "contractAddress.txt")
INTERFACECALLTEMPLATE="./templates/contractInterfaceCallTemplate0.txt"
INTERFACECALLTOSEND="./templates_to_send/testinterfacecall.txt"
FUNC="localCount"
VALUE="0"
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACECALLTEMPLATE} > "${INTERFACECALLTOSEND}" 

sudo docker cp "${INTERFACECALLTOSEND}" bootstrap:/root/testinterfacecall.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'

# Send interface
INTERFACETEMPLATE="./templates/contractInterfaceTemplate.txt"
INTERFACETEMPLATETOSEND="./templates_to_send/testinterface.txt"
FUNC="vote"
ARG=7000000
VALUE=5000000000000000000
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACETEMPLATE} > "${INTERFACETEMPLATETOSEND}"
sudo docker cp ${INTERFACETEMPLATETOSEND} bootstrap:/root/testinterface.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterface.txt")'

sleep 5

# Call interface for localcount
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'

# Connect node 1 and 2
sudo docker exec -it bootstrap bash /root/get_enode.sh
sudo docker exec -it ethereum-docker_eth_1 bash /root/get_enode.sh
sudo docker exec -it ethereum-docker_eth_2 bash /root/get_enode.sh

