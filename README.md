# Prometheus

- https://github.com/prometheus/prometheus
- https://github.com/prometheus/node_exporter
- https://github.com/prometheus-community/windows_exporter

## DNS

- http://prom-server.razumovsky.me
- http://prom-server.razumovsky.me:9090
- http://linux-target.razumovsky.me
- http://linux-target.razumovsky.me:9100/metrics
- http://windows-target.razumovsky.me
- http://windows-target.razumovsky.me:9182/metrics

## SSH connection

- ssh razumovsky_r@prom-server.razumovsky.me
- ssh razumovsky_r@linux-target.razumovsky.me

## Configure exporters and server

- Server: `wget https://raw.githubusercontent.com/kolosovpetro/prometheus-learning/refs/heads/master/scripts/Install-Linux-Prometheus-Server.sh && sudo chmod +x Install-Linux-Prometheus-Server.sh && sudo ./Install-Linux-Prometheus-Server.sh`
- Linux exporter: `wget https://raw.githubusercontent.com/kolosovpetro/prometheus-learning/master/scripts/Install-Linux-Node-Exporter.sh && sudo chmod +x Install-Linux-Node-Exporter.sh && sudo ./Install-Linux-Node-Exporter.sh`
- Windows exporter: `$scriptUrl = "https://raw.githubusercontent.com/kolosovpetro/prometheus-learning/master/scripts/Install-Windows-Exporter.ps1";$localScriptPath = "$env:TEMP\Install-Windows-Exporter.ps1";Invoke-WebRequest -Uri $scriptUrl -OutFile $localScriptPath;PowerShell -ExecutionPolicy Bypass -File $localScriptPath`

## Docs

- Daemon using outdated libraries fix: https://stackoverflow.com/q/73397110
    - `/etc/needrestart/needrestart.conf`
    - `$nrconf{restart} = 'a';`

## Notes

- Linux default scrape port: 9100
- Windows default scrape port: 9182
