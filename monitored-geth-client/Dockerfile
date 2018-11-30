FROM ethereum/client-go
MAINTAINER Volker Strobel <volker.strobel87@gmail.com>			

USER root

RUN apk add --update git bash nodejs nodejs-npm perl python build-base
RUN npm install -g npm@next
RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2 --unsafe &&\
    npm install solc@0.4.25 --unsafe &&\
    npm install web3 --unsafe

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod +x /root/start.sh

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod +x /root/start.sh

COPY ../remote_scripts /root/ 

# Use this line to save time (i.e., you don't need to create the DAG)
ADD dag/full-R23-0000000000000000 /root/.ethash/full-R23-0000000000000000

ENTRYPOINT /root/start.sh
