Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$masterPublicIp = $( terraform output -raw "master_public_ip" )

if (!$env:SLACK_WEBHOOK_URL)
{
    Write-Error "Environment variable slack url is not set."
    exit 1
}

$sedCommand = "sudo sed -i 's|https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX|$env:SLACK_WEBHOOK_URL|' /etc/alertmanager/alertmanager.yml"

ssh -o StrictHostKeyChecking=no razumovsky_r@$($masterPublicIp) $sedCommand
ssh -o StrictHostKeyChecking=no razumovsky_r@$($masterPublicIp) "sudo systemctl daemon-reload && sudo systemctl restart alertmanager.service && sudo systemctl status alertmanager.service --no-pager"

Write-Host "Slack configured successfully!" -ForegroundColor Green

exit 0
