# MongoDB Replication

## Concepts

What is replication? Replication is the concept of maintaining multiple copies of your data.

Why is replication necessary? Because you can't assume that all of your servers will be always available. For example, during a scheduled maintenance one of your cluster will become unavailable or a disaster could happen with one of your cluster's region.

If you have a replica set with 3 members (1 primary and 2 secondaries) and the two secondaries become unavailable for any reason, Mongodb automaticaly change the role of the primary node to secondary. This is a mecanism that keeps data safe and consistent in case of problems with topology.

Elections take place whenever there is a change in topology or a reconfig in replica set, it may or may not come up with a new primary. The method to figure out which secondary will run for election begins with the priority and whichever has the latest copy data.
A node with priority 0 can vote for election but it cannot run for election.

## Setup your environment
### Infrastructure
Creating the keyfile:

```
sudo mkdir -p /var/mongodb/pki/
sudo chown $USER /var/mongodb/pki/
openssl rand -base64 741 > /var/mongodb/pki/dbst-keyfile
chmod 400 /var/mongodb/pki/dbst-keyfile
```

Creating a db path and log path for all nodes:

```
mkdir -p /var/mongodb/db/node{1,2,3,4,5}
mkdir -p /var/mongodb/logs/node{1,2,3,4,5}
```

Starting first mongod node:

```
mongod -f configs/node1.yaml
mongod -f configs/node2.yaml
mongod -f configs/node3.yaml
```

Check if they are all running:
```
ps aux | grep mongod
```

### ReplicaSet

Connecting to *node1*:
```
mongo --port 27011
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
mongo --host "dbst-replset/localhost:27011" -u "rs-admin" -p "P4ssw0rd;" --authenticationDatabase "admin"
```

Getting replica set status:
```
rs.status()
```

Adding other members to replica set:
```
rs.add("localhost:27012")
rs.add("localhost:27013")
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