Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$masterPublicIp = $( terraform output -raw "master_public_ip" )

scp -o StrictHostKeyChecking=no ./prometheus/prometheus.yml razumovsky_r@$($masterPublicIp):/tmp/prometheus.yml
ssh -o StrictHostKeyChecking=no razumovsky_r@$($masterPublicIp) "sudo mv -f /tmp/prometheus.yml /etc/prometheus/prometheus.yml"
ssh -o StrictHostKeyChecking=no razumovsky_r@$($masterPublicIp) "cat /etc/prometheus/prometheus.yml"

$restartCommand = "sudo systemctl daemon-reload && sudo systemctl restart prometheus.service && sudo systemctl status prometheus.service --no-pager"

ssh -o StrictHostKeyChecking=no razumovsky_r@$($masterPublicIp) $restartCommand

Write-Host "Prometheus configured successfully!" -ForegroundColor Green

exit 0
