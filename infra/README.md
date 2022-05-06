# MongoDB Infrastructure

This code provisions a basic Linux Virtual Machine, with Ubuntu 20.04, with a Public IP and a Network Security Group

## Installing MongoDB

```
wget https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/5.0/multiverse/binary-amd64/mongodb-org-server_5.0.8_amd64.deb

sudo dpkg -i mongodb-org-server_5.0.8_amd64.deb

mongod --version
```