#!/bin/bash

# TODO: This can be done via docker-compose!
# Start mining


N=20

for i in {1..20}
do
    echo "$i"
    sudo docker exec -it ethereum-docker_eth_$i bash /root/exec_cmd.sh "miner.start(1)"
done

