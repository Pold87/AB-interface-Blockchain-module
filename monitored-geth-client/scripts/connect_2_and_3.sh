# Get enode of 2
docker exec -it ethereum-docker_eth_2 bash /root/scripts/get_enode.sh
enode2=`docker exec -it ethereum-docker_eth_2 cat my_enode.enode`

# Connect 2 to 3
docker exec -it ethereum-docker_eth_3 bash /root/scripts/enode_connect.sh ${enode2}
