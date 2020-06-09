#!/bin/bash

# Start mining

N=1

sudo docker exec -it bootstrap bash /root/get_enode.sh
#sudo docker exec -it bootstrap cat /root/my_enode.enode

for i in {1..2}
do
    echo "$i"
    sudo docker exec -it ethereum-docker_eth_$i bash /root/get_enode.sh
    #sudo docker exec -it ethereum-docker_eth_$i cat /root/my_enode.enode
done

