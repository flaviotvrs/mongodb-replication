# MongoDB Replication : Single hosted deployment

## Infrastructure
In order to be able to exercise all concepts of this lab please provision 3 virtual machines - or phisical machines - in a network where they can reach each other and install MongoDB version 5 on each of them.

I've terraformed this required environment for you, please take a look at [this instructions](./infra/README.md).

Or you can execute this script on a single machine, for example your own laptop. Just pretend that each running process of `mongod` is an independent node and it will work as well.

## Initial VM config

On your local environment generate one keyfile that will be used for the nodes to authenticate with each other:

```
openssl rand -base64 741 > ./heineken-keyfile
chmod 400 ./heineken-keyfile
```

Creating a db path and log path for each node:

```
sudo mkdir -p /var/mongodb/db/node{1,2,3}
sudo mkdir -p /var/mongodb/logs/node{1,2,3}
sudo mkdir -p /var/mongodb/pki
sudo chown -R ftavares /var/mongodb
```

Upload this keyfile into all your nodes:
```
scp heineken-keyfile ftavares@remote_host_n:/var/mongodb/pki/heineken-keyfile
```

Starting mongod proccess for each node:

```
mongod -f deployments/single-hosted/node-01.yaml
mongod -f deployments/single-hosted/node-02.yaml
mongod -f deployments/single-hosted/node-03.yaml
```

Check if the proccess is running:
```
ps aux | grep mongod
```

Monitor the logs of mongod proccess:
```
tail -f /var/mongodb/logs/node1/mongod.log
tail -f /var/mongodb/logs/node2/mongod.log
tail -f /var/mongodb/logs/node3/mongod.log
```

## Configuring ReplicaSet

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
mongosh --host "dbst-replset/localhost:27011" -u "dbadmin" -p "P4ssw0rd;" --authenticationDatabase "admin"
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