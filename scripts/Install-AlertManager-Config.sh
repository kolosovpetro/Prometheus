#!/bin/bash

# URLS
CONFIG_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/alertmanager.yml"
CPU_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/cpu_rules.yml"
RAM_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/memory_rule.yml"
STORAGE_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/storage_rule.yml"
SHUTDOWN_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/instance_shutdown_rules.yml"

# PATHS
CONFIG_PATH="/etc/alertmanager/alertmanager.yml"
CPU_RULES_PATH="/etc/alertmanager/cpu_rules.yml"
RAM_RULES_PATH="/etc/alertmanager/memory_rules.yml"
STORAGE_RULES_PATH="/etc/alertmanager/storage_rule.yml"
SHUTDOWN_RULES_PATH="/etc/alertmanager/instance_shutdown_rules.yml"

sudo mkdir -p /etc/alertmanager
sudo wget -O "$CONFIG_PATH" "$CONFIG_URL"
sudo wget -O "$CPU_RULES_PATH" "$CPU_RULES_URL"
sudo wget -O "$RAM_RULES_PATH" "$RAM_RULES_URL"
sudo wget -O "$STORAGE_RULES_PATH" "$STORAGE_RULES_URL"
sudo wget -O "$SHUTDOWN_RULES_PATH" "$SHUTDOWN_RULES_URL"
