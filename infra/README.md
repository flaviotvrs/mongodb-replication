# MongoDB Replication : Infrastructure

This code provisions an environment composed by 3 basic Linux Virtual Machine, with Ubuntu 20.04, with a Public IP and a Network Security Group. The purpose of this infrastructure is to setup a MongoDB replica set.

## Requirements
* [Terraform](https://www.terraform.io/) version `1.1.7`

## Step by step

### Provision Infrasucture
Execute terraform apply command below to have your virtual machines created on Azure cloud.

```
terraform apply
```

### Install MongoDB

For each node you have in your topology you'll have to install MongoDB
```
wget https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/5.0/multiverse/binary-amd64/mongodb-org-server_5.0.8_amd64.deb

sudo dpkg -i mongodb-org-server_5.0.8_amd64.deb

mongod --version
```

### Check out repository
For each node you have in your topology you'll have to checkout this repository
```
git clone https://github.com/flaviotvrs/mongodb-replication.git git/mongodb-replication
cd git/mongodb-replication
```

### Resume Replicaset set up
[MongoDB Replication](../README.md)
