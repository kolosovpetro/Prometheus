#!/bin/bash

echo "Adding repositories"

sudo DEBIAN_FRONTEND=noninteractive add-apt-repository main -y
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository universe -y
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository restricted -y
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository multiverse -y

echo "Get update package list"

sudo apt-get update -y

echo "Install nginx and build essential"

sudo apt-get install -y build-essential
sudo apt-get install -y nginx