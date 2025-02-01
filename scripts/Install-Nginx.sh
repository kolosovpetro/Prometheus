#!/bin/bash

echo "Adding repositories"

sudo add-apt-repository main
sudo add-apt-repository universe
sudo add-apt-repository restricted
sudo add-apt-repository multiverse

echo "Get update package list"

sudo apt-get update

echo "Install nginx and build essential"

sudo apt-get install -y build-essential
sudo apt-get install -y nginx