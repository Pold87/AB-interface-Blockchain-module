# Ethereum Docker

To run a single test Ethereum node run the following:

```
$ docker-compose -f docker-compose-standalone.yml up -d
```

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
docker-compose scale eth=3
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
