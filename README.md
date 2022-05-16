# MongoDB Replication

## Concepts

What is replication? Replication is the concept of maintaining multiple copies of your data.

Why is replication necessary? Because you can't assume that all of your servers will be always available. For example, during a scheduled maintenance one of your cluster will become unavailable or a disaster could happen with one of your cluster's region.

If you have a replica set with 3 members (1 primary and 2 secondaries) and the two secondaries become unavailable for any reason, Mongodb automaticaly change the role of the primary node to secondary. This is a mecanism that keeps data safe and consistent in case of problems with topology.

Elections take place whenever there is a change in topology or a reconfig in replica set, it may or may not come up with a new primary. The method to figure out which secondary will run for election begins with the priority and whichever has the latest copy data.
A node with priority 0 can vote for election but it cannot run for election.

## Setup your environment

### Infrastructure
To be able to exercise all concepts of this lab please pick one of the deployments listed [here](./deployments) and apply it in order to have your infrastructre set up. Each deployment has simple and straightforward instructions to provision infrastructure and install all the required software.

Or you can execute this script on a single machine, for example your own laptop. Just make sure that you have the requirements below installed on your machine.
Using a single machine you can simulate that each running process of `mongod` is an independent node and it will work as well.

### Requirements

One or more virtual machines with the following software:
* [MongoDB Community Server](https://www.mongodb.com/try/download/community)
* [MongoDB Shell](https://www.mongodb.com/try/download/shell)

### Configuring ReplicaSet

Connecting to one of your nodes using the localhost exception:
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
mongosh --host "replset-name/host-1:27017" -u "dbadmin" -p "P4ssw0rd;" --authenticationDatabase "admin"
```

Getting replica set status:
```
rs.status()
```

Adding other members to replica set:
```
rs.add("host-2:27017")
rs.add("host-3:27017")
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

Connecting to the whole replica set:
```
mongosh "mongodb://dbadmin:P4ssw0rd;@host-1:27017,host-2:27017,host-3:27017/?replicaSet=replset-name&authSource=admin&directConnection=true"
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