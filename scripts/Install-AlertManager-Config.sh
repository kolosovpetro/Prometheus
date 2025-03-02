#!/bin/bash

# URLS
ALERT_MANAGER_CONFIG_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/alertmanager.yml"
PROMETHEUS_CONFIG_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/prometheus.yml"
CPU_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/cpu_rules.yml"
RAM_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/memory_rule.yml"
STORAGE_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/storage_rule.yml"
SHUTDOWN_RULES_URL="https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/prometheus/instance_shutdown_rules.yml"

# PATHS
PROMETHEUS_CONFIG_PATH="/etc/prometheus/prometheus.yml"
ALERT_MANAGER_CONFIG_PATH="/etc/alertmanager/alertmanager.yml"
CPU_RULES_PATH="/etc/alertmanager/cpu_rules.yml"
RAM_RULES_PATH="/etc/alertmanager/memory_rules.yml"
STORAGE_RULES_PATH="/etc/alertmanager/storage_rule.yml"
SHUTDOWN_RULES_PATH="/etc/alertmanager/instance_shutdown_rules.yml"

sudo mkdir -p /etc/alertmanager
sudo mkdir -p /etc/prometheus


sudo wget -O "$PROMETHEUS_CONFIG_PATH" "$PROMETHEUS_CONFIG_URL"
sudo wget -O "$ALERT_MANAGER_CONFIG_PATH" "$ALERT_MANAGER_CONFIG_URL"
sudo wget -O "$CPU_RULES_PATH" "$CPU_RULES_URL"
sudo wget -O "$RAM_RULES_PATH" "$RAM_RULES_URL"
sudo wget -O "$STORAGE_RULES_PATH" "$STORAGE_RULES_URL"
sudo wget -O "$SHUTDOWN_RULES_PATH" "$SHUTDOWN_RULES_URL"

sudo systemctl daemon-reload
sudo systemctl restart prometheus
sudo systemctl restart alertmanager

sudo systemctl status prometheus --no-pager
sudo systemctl status alertmanager --no-pager
