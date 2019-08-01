# Interface for sending a transaction to a smart contract
INTERFACETEMPLATE="/root/templates/eventInterfaceTemplate0.txt"
ABI=$1 # This is the ABI file which provides all functions of the SC
ADDRESS=$2 # Address of the deployed smart contract
sed -e "s/ABI/${ABI}/g" -e "s/ADDRESS/${ADDRESS}/g" ${INTERFACETEMPLATE} > command.txt
bash /root/exec_template.sh command.txt
