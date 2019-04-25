docker stack rm ethereum
sleep 5
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
