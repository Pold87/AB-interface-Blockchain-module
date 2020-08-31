# Build Geth in a stock Go builder container
FROM golang:1.13-alpine as builder
MAINTAINER Volker Strobel <volker.strobel87@gmail.com>			

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD ./myowngeth /go-ethereum
RUN cd /go-ethereum && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 8547 30303 30303/udp

USER root
WORKDIR /root/

RUN apk add --no-cache --update git bash nodejs nodejs-npm perl python3 build-base
RUN  npm config set unsafe-perm true && npm install -g npm@next && npm config set unsafe-perm false
RUN cd /root &&\
    #git clone https://github.com/cubedro/eth-net-intelligence-api &&\
   #cd eth-net-intelligence-api &&\
    #npm install &&\
    #npm install -g pm2 --unsafe &&\
    cd /root &&\
    npm install solc@0.4.25 --unsafe &&\
    npm install web3@1.2.6 --unsafe

COPY ./scripts /root/
COPY ./files/password /root/files/password
COPY ./templates /root/
RUN chmod +x /root/start.sh
RUN chmod +x /root/start_bootstrap.sh
ADD app.json /root/eth-net-intelligence-api/app.json

ENTRYPOINT /root/start.sh
