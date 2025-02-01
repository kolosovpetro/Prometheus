#!/bin/bash

# Variables
NODE_EXPORTER_VERSION="1.8.2"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
NODE_EXPORTER_USER="node_exporter"
NODE_EXPORTER_BIN="/usr/local/bin/node_exporter"
NODE_EXPORTER_SERVICE="/etc/systemd/system/node_exporter.service"

echo "Update need restart conf"

sudo curl -o /etc/needrestart/needrestart.conf https://raw.githubusercontent.com/kolosovpetro/prometheus-learning/refs/heads/master/needrestart.conf

# Update and upgrade the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Download Node Exporter
echo "Downloading Node Exporter v${NODE_EXPORTER_VERSION}..."
wget $NODE_EXPORTER_URL -O /tmp/node_exporter.tar.gz

# Extract the archive
echo "Extracting Node Exporter..."
tar -xvzf /tmp/node_exporter.tar.gz -C /tmp/

# Move binary to /usr/local/bin
echo "Installing Node Exporter..."
sudo mv /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter $NODE_EXPORTER_BIN
sudo chmod +x $NODE_EXPORTER_BIN

# Create node_exporter user
echo "Creating node_exporter user..."
sudo useradd --no-create-home --shell /bin/false $NODE_EXPORTER_USER

# Set up systemd service
echo "Setting up Node Exporter systemd service..."
cat << EOF | sudo tee $NODE_EXPORTER_SERVICE
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$NODE_EXPORTER_USER
Group=$NODE_EXPORTER_USER
Type=simple
ExecStart=$NODE_EXPORTER_BIN

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Node Exporter
echo "Starting Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Verify installation
echo "Checking Node Exporter status..."
if sudo systemctl status node_exporter | grep -q "active (running)"; then
    echo "Node Exporter installed and running successfully!"
    echo "Verify metrics by visiting: http://<server-ip>:9100/metrics"
else
    echo "Node Exporter installation failed. Check logs with: sudo journalctl -u node_exporter"
fi

# Cleanup
echo "Cleaning up..."
rm -rf /tmp/node_exporter.tar.gz /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64

echo "Installation complete!"
