Write-Host "Change directory to root"

# Save the current location
$originalLocation = Get-Location

Set-Location (Split-Path -Path $PSScriptRoot -Parent)

$masterNodePublicIp = $(terraform output -raw prometheus_master_public_ip)
$windowsTargetPublicIp = $(terraform output -raw windows_target_public_ip)
$linuxTargetPublicIp = $(terraform output -raw linux_target_public_ip)

$dnsRecords = @{}

$dnsRecords["prometheus-master.razumovsky.me"] = $masterNodePublicIp
$dnsRecords["linux-target.razumovsky.me"] = $linuxTargetPublicIp
$dnsRecords["windows-target.razumovsky.me"] = $windowsTargetPublicIp

Set-Location $originalLocation

return $dnsRecords
