#!/bin/bash

set -e

# === INPUT ===
artifactZip="$1"  # e.g., /tmp/movies.zip

# === CONFIG ===
NginxPhysicalPath="/var/www/movies"
NginxConfigPath="/etc/nginx/conf.d"
NginxSiteHostName="movies.razumovsky.me"
NginxConfigFileName="$NginxSiteHostName.conf"
user="razumovsky_r"

echo ">>> Creating site folder..."
sudo mkdir -p "$NginxPhysicalPath"

echo ">>> Unzipping artifact..."
sudo unzip -o "$artifactZip" -d "$NginxPhysicalPath"

echo ">>> Setting permissions for appsettings.json..."
sudo chmod -R 777 "$NginxPhysicalPath/appsettings.json"

echo ">>> Creating systemd service file..."
sudo tee "$NginxPhysicalPath/movies.service" > /dev/null <<END
[Unit]
Description=Movies API Backend Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$NginxPhysicalPath
ExecStart=$NginxPhysicalPath/MoviesAPI.Core
User=$user
Group=$user

[Install]
WantedBy=multi-user.target
END

echo ">>> Installing systemd service..."
sudo cp "$NginxPhysicalPath/movies.service" /etc/systemd/system/
sudo chmod 600 /etc/systemd/system/movies.service

echo ">>> Running idempotent service startup script..."
cd "$NginxPhysicalPath"
sudo chmod +x idempotent_service_run.sh
./idempotent_service_run.sh

echo ">>> Creating NGINX config..."
sudo tee "$NginxConfigPath/$NginxConfigFileName" > /dev/null <<END
server {
  server_name $NginxSiteHostName;

  location / {
    include proxy_params;
    proxy_pass http://127.0.0.1:5189;
  }

  location /swagger {
    include proxy_params;
    proxy_pass http://127.0.0.1:5189;
  }

  location /api {
    include proxy_params;
    proxy_pass http://127.0.0.1:5189;
  }
}
END

echo ">>> Restarting and validating NGINX..."
sudo systemctl restart nginx
sudo systemctl status nginx
sudo nginx -T

echo "✅ Deployment script completed on remote VM."
