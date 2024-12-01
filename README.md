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

## Creating scrape service

- sudo vim /etc/systemd/system/linux.node.exporter.service
- sudo systemctl daemon-reload 
- sudo systemctl start linux.node.exporter.service
- sudo systemctl enable linux.node.exporter.service
- systemctl status linux.node.exporter.service

## Notes

- Linux default scrape port: 9100
- Windows default scrape port: 9182
