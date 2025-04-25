Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$masterPublicIp = $( terraform output -raw "master_public_ip" )

scp ./prometheus/prometheus.yml razumovsky_r@$($masterPublicIp):/tmp/prometheus
ssh razumovsky_r@$($masterPublicIp) "sudo mv /tmp/prometheus /etc/prometheus"

$restartCommand = "sudo systemctl daemon-reload && sudo systemctl restart prometheus.service && sudo systemctl status prometheus.service --no-pager"

ssh razumovsky_r@$($masterPublicIp) $restartCommand

Write-Host "Prometheus configured successfully!" -ForegroundColor Green

exit 0
