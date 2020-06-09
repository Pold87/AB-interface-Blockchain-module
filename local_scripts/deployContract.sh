CONTRACTBASE="Voting"
TEMPLATE="contractTemplate.txt"

# Compile contract
#sudo docker pull ethereum/solidity:stable
sudo docker run -v $(pwd):/tmp --workdir /tmp ethereum/solc:stable --overwrite --abi --bin -o . ${CONTRACTBASE}.sol

INTERFACE=`cat "${CONTRACTBASE}.abi"`
DATA=`cat "${CONTRACTBASE}.bin"`
DATA="0x${DATA}"

echo $INTERFACE
echo $TEMPLATE

sed -e "s/INTERFACE/${INTERFACE}/g" ${TEMPLATE} > contract.txt
sed -i -e "s/DATA/${DATA}/g" contract.txt

# Start mining
sudo docker exec -it bootstrap bash /root/exec_cmd.sh "miner.start(1)"

# Unlock account
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/unlockAccount.txt")'

# Deploy contract
ADDRESS=`sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/contract.txt")'`
ADDRESS=`echo $ADDRESS | sed 's/.*\(0[xX][0-9a-fA-F]\+\).*/\1/'`
echo "add is $ADDRESS"
# Interact with smart contract (send a vote)
RAMA="0x`echo -n Rama | hexdump -e '/1 "%02x"'; echo`"
INTERFACETEMPLATE="contractInterfaceTemplate.txt"
FUNC="voteForCandidate"
ARG="${RAMA}"
VALUE="0"
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACETEMPLATE} > testinterface.txt
sudo docker cp testinterface.txt bootstrap:/root/testinterface.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterface.txt")'

INTERFACECALLTEMPLATE="contractInterfaceCallTemplate.txt"
sed -e "s/INTERFACE/${INTERFACE}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACECALLTEMPLATE} > testinterfacecall.txt
sudo docker cp testinterfacecall.txt bootstrap:/root/testinterfacecall.txt
sudo docker exec -it bootstrap bash /root/exec_cmd.sh 'loadScript("/root/testinterfacecall.txt")'
