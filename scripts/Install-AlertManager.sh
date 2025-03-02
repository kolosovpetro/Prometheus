#!/bin/bash

cd /opt || exit
sudo wget https://github.com/prometheus/alertmanager/releases/download/v0.28.0/alertmanager-0.28.0.linux-386.tar.gz
sudo tar -xvf alertmanager-0.28.0.linux-386.tar.gz
cd alertmanager-0.28.0.linux-386 || exit
sudo mv alertmanager /usr/local/bin/
sudo mv amtool /usr/local/bin/
