# ARGoS-Blockchain interface: Blockchain module (Module 1)

This blockchain module allows for creating an Ethereum network with several
nodes, where each node is located in a separate Docker container. For
the ARGoS-Blockchain interface, the interaction with the Ethereum
nodes is done via C++, using the code in the following repository:
https://github.com/Pold87/robot-swarms-need-blockchain

This repository contains one module of the ARGoS-Blockchain interface
that is described in the article [Blockchain Technology Secures Robot
Swarms: A Comparison of Consensus Protocols and Their Resilience to
Byzantine
Robots](https://www.frontiersin.org/articles/10.3389/frobt.2020.00054/full)
by [Strobel, V.](http://iridia.ulb.ac.be/~vstrobel/), [Castello
Ferrer, E.](http://www.eduardocastello.com/), and [Dorigo,
M.](http://iridia.ulb.ac.be/~mdorigo/HomePageDorigo/).

For debugging purposes or for creating your own private Ethereum
network, you can also use this module without ARGoS. 

## Overview of the interface
![Overview](img/interface.png?raw=true "Overview")

## Setup

The very first time you run this code, it is required to create the
Docker image for the Ethereum nodes and initialize Docker Swarm as
follows:

```
cd geth/
docker build -t mygeth .
docker swarm init
```

Additionally, you have to set the variable `DOCKERFOLDER` in
the file `global_config.sh` to the full path where this
repository is located on your computer, for example:

```
/Users/vstrobel/Documents/ARGoS-Blockchain-interface/
```

In order to be able to mine, you need to create the [DAG
datasets](https://eth.wiki/concepts/ethash/dag) as follows (creating
the files requires approximately 2 GB disk space and executing the
script can take take several minutes):

```
bash local_scripts/create_dag.sh
```

If you get an error in any of the stepts, try executing:

```
bash local_scripts/stop_network.sh
```

## Run

Usually, the network is created when a swarm robotics experiment is
started, using one of the start scripts in
[https://github.com/Pold87/robot-swarms-need-blockchain](https://github.com/Pold87/robot-swarms-need-blockchain).

However, you can also start the Ethereum network without ARGoS, using
the following command:

```bash local_scripts/start_network.sh <number of nodes>```

That is, `bash local_scripts/start_network.sh 5`, would
create a private Ethereum network with 5 nodes.
