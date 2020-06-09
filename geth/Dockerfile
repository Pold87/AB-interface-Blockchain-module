FROM ethereum/client-go:release-1.8
MAINTAINER Volker Strobel <volker.strobel87@gmail.com>			

USER root
WORKDIR /root/

RUN apk add --no-cache --update git bash nodejs nodejs-npm perl python build-base
RUN  npm config set unsafe-perm true && npm install -g npm@next && npm config set unsafe-perm false
RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2 --unsafe &&\
    cd /root &&\
    npm install solc@0.4.25 --unsafe &&\
    npm install web3@1.0.0-beta.48 --unsafe

COPY ./scripts /root/
COPY ./files/password /root/files/password
COPY ./templates /root/
RUN chmod +x /root/start.sh
RUN chmod +x /root/start_bootstrap.sh
ADD app.json /root/eth-net-intelligence-api/app.json

ENTRYPOINT /root/start.sh
