# ARGoS-Blockchain interface

This repository contains the ARGoS-Blockchain interface that is
described in the article [Blockchain Technology Secures Robot Swarms:
A Comparison of Consensus Protocols and Their Resilience to Byzantine
Robots](https://www.frontiersin.org/articles/10.3389/frobt.2020.00054/full)
by [Strobel, V.](http://iridia.ulb.ac.be/~vstrobel/), [Castello
Ferrer, E.](http://www.eduardocastello.com/), and [Dorigo,
M.](http://iridia.ulb.ac.be/~mdorigo/HomePageDorigo/).

See `img/interface.png` for an overview of the interface.

## Setup

```
cd geth/
docker build -t mygeth .
docker swarm init
```

## Run
To start experiments, you need the code in https://github.com/Pold87/robot-swarms-need-blockchain
