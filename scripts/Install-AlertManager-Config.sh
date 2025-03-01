#!/bin/bash

CONFIG_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/AZ400-330/prometheus/alertmanager.yml"  # Change this URL to your actual file
CONFIG_PATH="/etc/alertmanager/alertmanager.yml"

sudo mkdir -p /etc/alertmanager
sudo wget -O "$CONFIG_PATH" "$CONFIG_URL"
