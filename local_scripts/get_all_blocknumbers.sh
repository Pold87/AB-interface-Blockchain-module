#!/bin/bash

# Start mining

N=20

for i in {1..20}
do
    echo "$i"
    sudo docker exec -it ethereum-docker_eth_$i bash /root/exec_cmd.sh "eth.blockNumber"
done

