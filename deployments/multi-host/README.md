# MongoDB Replication : Multi host deployment

## Provision Infrastructure

Refer to the documentation [here](../../infra/README.md) to get a step by step guide to provision your infrastructure with all the required software.

Here are some commands to make your life easier when running terraform, but please **do not run these commands without reading the documentation described above**.
```shell
terraform -chdir=./infra/ init
terraform -chdir=./infra/ apply --var-file=../deployments/multi-host/infra/terraform.tfvars --state=../deployments/multi-host/infra/terraform.tfstate
```

## Initial VM config

On your local environment generate one keyfile that will be used for the nodes to authenticate with each other:

```shell
openssl rand -base64 741 > ./spaten-keyfile
chmod 400 ./spaten-keyfile
```

Creating a db path and log path for each node:
```shell
sudo mkdir -p /var/mongodb/db
sudo mkdir -p /var/mongodb/logs
sudo mkdir -p /var/mongodb/pki
sudo chown -R dbadmin /var/mongodb

```

Upload this keyfile into all your nodes:
```shell
scp ./spaten-keyfile dbadmin@remote-host:/var/mongodb/pki/spaten-keyfile
```

Check on the MongoDB [configuration files](./configs/) and make sure that the property `net.bindIp` is set to `localhost` and to the current VM's private IP address. Also check on the port, it must be set to `27017`. 
For example:
```yaml
net:
  bindIp: localhost,10.0.2.5
  port: 27017
```

Starting mongod proccess for each node:
```shell
mongod -f deployments/multi-host/configs/node-00.yaml
```

Check if the proccess is running:
```shell
ps aux | grep mongod
```

Monitor the logs of mongod proccess:
```shell
tail -f /var/mongodb/logs/mongod.log
```