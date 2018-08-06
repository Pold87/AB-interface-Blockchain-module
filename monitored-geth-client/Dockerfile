FROM ubuntu:18.04

LABEL version="1.0"
LABEL maintainer="shindu666@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --yes git bash nodejs npm perl emacs

RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2

RUN apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install --yes ethereum solc

RUN adduser --disabled-login --gecos "" eth_user

#COPY eth_common /home/eth_user/eth_common
#RUN chown -R eth_user:eth_user /home/eth_user/eth_common
#USER eth_user
#WORKDIR /home/eth_user

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod +x /root/start.sh

# Volker's adds
COPY scripts /root/scripts 
COPY smart_contracts /root/smart_contracts

RUN solc --overwrite --abi --bin -o . /root/smart_contracts/smart_contract.sol

ADD dag/full-R23-0000000000000000 /root/.ethash/full-R23-0000000000000000

ENTRYPOINT /root/start.sh

ENTRYPOINT bash

