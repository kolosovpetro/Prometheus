#!/bin/bash

# Define service file path
SERVICE_FILE="/etc/systemd/system/alertmanager.service"

echo "Creating Alertmanager systemd service file..."

# Create systemd service file
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Prometheus Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path=/var/lib/alertmanager
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Create alertmanager user if not exists
sudo id -u alertmanager &>/dev/null || sudo useradd --no-create-home --shell /bin/false alertmanager

# Set correct permissions
sudo mkdir -p /var/lib/alertmanager
sudo chown alertmanager:alertmanager /var/lib/alertmanager

# Reload systemd, enable & start Alertmanager
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

# Display service status
sudo systemctl status alertmanager --no-pager

echo "✅ Alertmanager service created and started successfully!"
