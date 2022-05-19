#!/usr/bin/env bash

# Documentation : https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-20-04/

# config
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

# checks
sudo swapon --show
sudo free -h
