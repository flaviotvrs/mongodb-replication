# MongoDB Replication : Single host deployment

## Provision Infrastructure

```
terraform -chdir=./infra/ init
terraform -chdir=./infra/ apply --var-file=../deployments/single-host/infra/terraform.tfvars --state=../deployments/single-host/infra/terraform.tfstate
```

## Initial VM config

On your local environment generate one keyfile that will be used for the nodes to authenticate with each other:

```
openssl rand -base64 741 > ./brahma-keyfile
chmod 400 ./brahma-keyfile
```

Creating a db path and log path for each node:

```
sudo mkdir -p /var/mongodb/db/node{1,2,3}
sudo mkdir -p /var/mongodb/logs/node{1,2,3}
sudo mkdir -p /var/mongodb/pki
sudo chown -R dbadmin /var/mongodb
```

Upload this keyfile into all your nodes:
```
scp brahma-keyfile dbadmin@remote-host:/var/mongodb/pki/brahma-keyfile
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