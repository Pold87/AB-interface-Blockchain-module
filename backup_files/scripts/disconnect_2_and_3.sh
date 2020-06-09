# Disconnect 2 to 3
enode2=`docker exec -it ethereum-docker_eth_2 cat my_enode.enode`

docker exec -it ethereum-docker_eth_3 bash /root/scripts/enode_disconnect.sh ${enode2}
