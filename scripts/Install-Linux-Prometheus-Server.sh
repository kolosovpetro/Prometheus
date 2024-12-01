#!/bin/bash

# Variables
PROMETHEUS_VERSION="3.0.1"
PROMETHEUS_USER="prometheus"
PROMETHEUS_DIR="/etc/prometheus"
PROMETHEUS_BIN="/usr/local/bin"
PROMETHEUS_SERVICE_FILE="/etc/systemd/system/prometheus.service"

# Update and upgrade the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Download Prometheus
echo "Downloading Prometheus v${PROMETHEUS_VERSION}..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz -O /tmp/prometheus.tar.gz

# Extract Prometheus
echo "Extracting Prometheus..."
tar -xvzf /tmp/prometheus.tar.gz -C /tmp/

# Move Prometheus files
echo "Installing Prometheus..."
sudo mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus $PROMETHEUS_BIN/
sudo mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool $PROMETHEUS_BIN/
sudo mkdir -p $PROMETHEUS_DIR /var/lib/prometheus
sudo mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles $PROMETHEUS_DIR/
sudo mv /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries $PROMETHEUS_DIR/

# Create Prometheus user
echo "Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false $PROMETHEUS_USER || true
sudo chown -R $PROMETHEUS_USER:$PROMETHEUS_USER $PROMETHEUS_DIR /var/lib/prometheus
sudo chown $PROMETHEUS_USER:$PROMETHEUS_USER $PROMETHEUS_BIN/prometheus $PROMETHEUS_BIN/promtool

# Create Prometheus config file
echo "Creating Prometheus configuration file..."
cat << EOF | sudo tee $PROMETHEUS_DIR/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: 
        - 'linux-target.razumovsky.me:9100'
        - 'windows-target.razumovsky.me:9100'
EOF
sudo chown $PROMETHEUS_USER:$PROMETHEUS_USER $PROMETHEUS_DIR/prometheus.yml

# Set up systemd service
echo "Setting up Prometheus systemd service..."
cat << EOF | sudo tee $PROMETHEUS_SERVICE_FILE
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=$PROMETHEUS_USER
Group=$PROMETHEUS_USER
Type=simple
ExecStart=$PROMETHEUS_BIN/prometheus \\
  --config.file=$PROMETHEUS_DIR/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=$PROMETHEUS_DIR/consoles \\
  --web.console.libraries=$PROMETHEUS_DIR/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Prometheus
echo "Starting and enabling Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Verify installation
if sudo systemctl is-active --quiet prometheus; then
    echo "Prometheus installed and running successfully!"
    echo "Access it via: http://<your-server-ip>:9090"
else
    echo "Prometheus installation failed. Check logs with: sudo journalctl -u prometheus"
fi

# Cleanup
echo "Cleaning up..."
rm -rf /tmp/prometheus.tar.gz /tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64

echo "Installation complete!"
