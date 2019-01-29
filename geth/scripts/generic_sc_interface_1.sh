# Interface for sending a transaction to a smart contract
INTERFACETEMPLATE="/root/templates/contractInterfaceTemplate.txt"
ABI=$1 # This is the ABI file which provides all functions of the SC
ADDRESS=$2 # Address of the deployed smart contract
FUNC=$3
ARG=$4
VALUE=$5
sed -e "s/ABI/${ABI}/g" -e "s/ADDRESS/${ADDRESS}/g" -e "s/FUNC/${FUNC}/g" -e "s/ARG/${ARG}/g" -e "s/VALUE/${VALUE}/g" ${INTERFACETEMPLATE} > command.txt
bash /root/exec_template.sh command.txt
