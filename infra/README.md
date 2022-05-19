# MongoDB Replication : Infrastructure

This code provisions an environment composed by N basic Linux Virtual Machine, with Ubuntu 18.04, with a Public IP and a Network Security Group. The purpose of this infrastructure is to setup a MongoDB replica set.

## Requirements
* [Terraform](https://www.terraform.io/) version `1.1.7` installed on your environment.
* An account set up and a subscription on [Azure](https://www.azure.com/).

## Step by step

### Provision Infrasucture

#### Terraform docs
Here is the documentation for the provisioning of the required infrastructure for MongoDB.

<!-- BEGIN_TF_DOCS -->
##### Requirements

| Name | Version |
|------|---------|
| terraform | 1.1.7 |
| azurerm | =3.5.0 |

##### Modules

| Name | Source | Version |
|------|--------|---------|
| mongodb-node | ./virtual-machine | n/a |
| network | ./network | n/a |
| resource-group | ./resource-group | n/a |

##### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | The name of the cluster. | `string` | n/a | yes |
| location | The location in which the replica set will be created. | `string` | n/a | yes |
| vm\_size | The size of the virtual machine. | `string` | n/a | yes |
| node\_count | The number of nodes in the cluster. | `number` | `3` | no |
| ssh\_ip\_address | The IP address to allow SSH access to the virtual machine. | `string` | `null` | no |
<!-- END_TF_DOCS -->

#### Applying infrastructure

After reading the documentation you should create a variables file that satisfies the above inputs and trigger terraform apply commands as shown below

```
terraform init
terraform -chdir=/path/to/infra/directory apply --var-file=path/to/terraform.tfvars --state=/path/to/terraform.tfstate
```

### Install MongoDB Server

For each node you have in your topology you'll have to install MongoDB Server
```
wget https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/5.0/multiverse/binary-amd64/mongodb-org-server_5.0.8_amd64.deb

sudo dpkg -i mongodb-org-server_5.0.8_amd64.deb

mongod --version
```

### Install MongoDB Shell

Pick one node where to install MongoDB Shell, it will be used later for initial setup
```
wget https://downloads.mongodb.com/compass/mongodb-mongosh_1.3.1_amd64.deb

sudo dpkg -i mongodb-mongosh_1.3.1_amd64.deb

mongosh --version
```

### Check out repository

For each node you have in your topology you'll have to checkout this repository
```
git clone https://github.com/flaviotvrs/mongodb-replication.git git/mongodb-replication
cd git/mongodb-replication
```

### Resume Replicaset set up
[MongoDB Replication](../README.md)
