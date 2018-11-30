# Imporant advice and TODOs

- Some functions, like addPeer do not work in web3 -> use the command line interface therefore
- There was a faulty solc version that caused many problems; the right version to install is solc@0.4.25: `npm install solc@0.4.25 --unsafe`
- You also need to install web3 via npm; there's a problem installing it from the Dockerfile. The problem is related to the user in docker; I think I had a solution but may have lost it.
- The Ethereum processes should be started outside of ARGoS: this way we can save time and other simulators can be used in a plug and play way
- The interface could be written in javascript (node) or bash; the advantage of bash is speed and ease of use; the advantage of javascript is that return values can be directly used;

# Ethereum Docker

If using docker-machine you should be able to get to the JSON RPC client by doing:

```
open http://$(docker-machine ip default):8545
```

Assuming you ran docker-compose against the ```default``` machine.

### Ethereum Cluster with netstats monitoring

To run an Ethereum Docker cluster run the following:

```
$ docker-compose up -d
```

By default this will create:

* 1 Ethereum Bootstrapped container
* 1 Ethereum container (which connects to the bootstrapped container on launch)
* 1 Netstats container (with a Web UI to view activity in the cluster)

To access the Netstats Web UI:

```
open http://$(docker-machine ip default):3000
```

### Scaling the number of nodes/containers in the cluster

You can scale the number of Ethereum nodes by running:

```
docker-compose up -d --scale eth=3
```

This will scale the number of Ethereum nodes **upwards** (replace 3 with however many nodes
you prefer). These nodes will connect to the P2P network (via the bootstrap node)
by default.

### Test accounts ready for use

As part of the bootstrapping process we bootstrap 10 Ethereum accounts for use
pre-filled with 20 Ether for use in transactions by default.

If you want to change the amount of Ether for those accounts
See `files/genesis.json`.

## Interact with geth

To get attached to the `geth` JavaScript console on the node you can run the following
```
docker exec -it ethereumdocker_eth_1 geth attach ipc://root/.ethereum/devchain/geth.ipc
```
Then you can `miner.start()`, and then check to see if it's mining by inspecting `web3.eth.mining`. 

See the [Javascript Runtime](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console) docs for more.

### Use an existing DAG

To speed up the process, you can use a [pre-generated DAG](https://github.com/ethereum/wiki/wiki/Ethash-DAG). All you need to do is add something like this
```
ADD dag/full-R23-0000000000000000 /root/.ethash/full-R23-0000000000000000
```
to the `monitored-geth-client` Dockerfile.
