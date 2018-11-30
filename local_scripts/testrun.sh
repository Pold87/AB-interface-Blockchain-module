# This script should maybe be executed outside of C++ because then, we
# can use it independently of ARgoS and start the experiments after the
# initialization phase has started

N=2
DOCKERFOLDER="/home/volker/Documents/mygithub-software/ethereum-docker/"
# Start Ethereum network using Docker 

# #cd ${DOCKERFOLDER} && sudo docker-compose down
cd ${DOCKERFOLDER} && sudo docker-compose up -d --scale eth=$N

CONTRACTBASE="smart_contract_threshold"

# Unlock account 
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/unlockAccount.txt")'

# Start mining
sudo docker exec -it bootstrap bash /root/exec_cmd.sh "miner.start(1)"

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
INTERFACECALLTEMPLATE="contractInterfaceCallTemplate0.txt"
FUNC="localCount"
VALUE="0"
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACECALLTEMPLATE} > testinterfacecall.txt

sudo docker cp testinterfacecall.txt bootstrap:/root/testinterfacecall.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'

# Send interface
INTERFACETEMPLATE="contractInterfaceTemplate.txt"
FUNC="vote"
ARG=7000000
VALUE=5000000000000000000
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACETEMPLATE} > testinterface.txt
sudo docker cp testinterface.txt bootstrap:/root/testinterface.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterface.txt")'

sleep 5

# Call interface for localcount
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'

# Connect node 1 and 2
sudo docker exec -it bootstrap bash /root/get_enode.sh
sudo docker exec -it ethereum-docker_eth_1_331121bd997b bash /root/get_enode.sh
sudo docker exec -it ethereum-docker_eth_2_7a86b644338f bash /root/get_enode.sh

