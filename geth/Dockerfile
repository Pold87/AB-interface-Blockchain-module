FROM ethereum/client-go
MAINTAINER Volker Strobel <volker.strobel87@gmail.com>			

USER root
WORKDIR /root/

RUN apk add --no-cache --update git bash nodejs nodejs-npm perl python build-base
RUN npm install -g npm@next
RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2 --unsafe &&\
    cd /root &&\
    npm install solc@0.4.25 --unsafe &&\
    npm install web3 --unsafe

COPY ./templates/ /root/templates/
COPY ./scripts /root/
RUN chmod +x /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json

ENTRYPOINT /root/start.sh
