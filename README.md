# MongoDB Replication

## Concepts

What is replication? Replication is the concept of maintaining multiple copies of your data.

Why is replication necessary? Because you can't assume that all of your servers will be always available. For example, during a scheduled maintenance one of your cluster will become unavailable or a disaster could happen with one of your cluster's region.

If you have a replica set with 3 members (1 primary and 2 secondaries) and the two secondaries become unavailable for any reason, Mongodb automaticaly change the role of the primary node to secondary. This is a mecanism that keeps data safe and consistent in case of problems with topology.

Elections take place whenever there is a change in topology or a reconfig in replica set, it may or may not come up with a new primary. The method to figure out which secondary will run for election begins with the priority and whichever has the latest copy data.
A node with priority 0 can vote for election but it cannot run for election.

## Setup your environment

### Infrastructure
In order to be able to exercise all concepts of this lab please provision 3 virtual machines - or phisical machines - in a network where they can reach each other and install MongoDB version 5 on each of them.

I've terraformed this required environment for you, please take a look at [this instructions](./infra/README.md).

Or you can execute this script on a single machine, for example your own laptop. Just pretend that each running process of `mongod` is an independent node and it will work as well.

### Initial setup

On your local environment generate one keyfile that will be used for the nodes to authenticate with each other:

```
openssl rand -base64 741 > ./dbst-keyfile
chmod 400 ./dbst-keyfile
```

Creating a db path and log path for each node:

```
sudo mkdir -p /var/mongodb/db
sudo mkdir -p /var/mongodb/logs
sudo mkdir -p /var/mongodb/pki
sudo chown -R dbadmin /var/mongodb
```

Upload this keyfile into all your nodes:
```
scp dbst-keyfile dbadmin@remote_host_n:/var/mongodb/pki/dbst-keyfile
```

Starting mongod proccess for each node:

```
mongod -f configs/node-ubuntu.yaml
```

Check if the proccess is running:
```
ps aux | grep mongod
```

Monitor the logs of mongod proccess:
```
tail -f /var/mongodb/logs/mongod.log
```

### Configuring ReplicaSet

Connecting to one of your nodes:
```
mongosh --port 27017
```

Initiating the replica set:
```
rs.initiate()
```

Creating a user:
```
use admin
db.createUser({
  user: "dbadmin",
  pwd: "P4ssw0rd;",
  roles: [
    {role: "root", db: "admin"}
  ]
})
```

Exiting out of the Mongo shell and connecting to the entire replica set:
```
exit
mongosh --host "dbst-replset/remote_host_1:27017" -u "dbadmin" -p "P4ssw0rd;" --authenticationDatabase "admin"
```

Getting replica set status:
```
rs.status()
```

Adding other members to replica set:
```
rs.add("remote_host_2:27017")
rs.add("remote_host_3:27017")
...
```

Getting an overview of the replica set topology:
```
rs.isMaster()
```

Stepping down the current primary:
```
rs.stepDown()
```

## Useful commands

Checks the current status of your replicaset, for example: how many members it has, a description of all members, which one is the primary or secondary, etc.
```
rs.status()
```


Shows some info about your replicaset, just like `rs.status()` but it is easier to read because it is more succint.
```
rs.isMaster()
```

This one is pretty much the same as `rs.isMaster()` except for one additional field named `rbid` that counts the number of rollbacks that ever occurred on your cluster.
```
db.serverStatus()["repl"]
```

Shows information about oplog of the node you are connected to.
```
rs.printReplicationInfo()
```

Prints a formatted report of the replica set status from the perspective of the secondary member of the set.
```
rs.printSecondaryReplicationInfo()
```