# Prometheus

## URLs

- prometheus.server.razumovsky.me
- prometheus.target.razumovsky.me

## SSH connection

- ssh razumovsky_r@prometheus.server.razumovsky.me
- ssh razumovsky_r@prometheus.target.razumovsky.me

## Creating scrape service

- sudo vim /etc/systemd/system/linux.node.exporter.service
- sudo systemctl daemon-reload 
- sudo systemctl start linux.node.exporter.service
- sudo systemctl enable linux.node.exporter.service
- systemctl status linux.node.exporter.service

## Notes

- Linux default scrape port: 9100
