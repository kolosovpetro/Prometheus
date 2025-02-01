# Connect-AzAccount
$ErrorActionPreference = "Stop"

Update-AzConfig -DefaultSubscriptionForLogin $env:KOLOSOVP94_MPN_SUB_ID

$SecureClientSecret = ConvertTo-SecureString -String $env:KOLOSOVP94_MPN_SUB_CLIENT_SECRET `
    -AsPlainText -Force;$connectCreds=[PSCredential]::new($env:KOLOSOVP94_MPN_SUB_CLIENT_ID, $SecureClientSecret);

Connect-AzAccount -ServicePrincipal -Credential $connectCreds -Tenant $env:KOLOSOVP94_MPN_SUB_TENANT_ID

Set-AzContext -SubscriptionId $env:KOLOSOVP94_MPN_SUB_ID

# Define the resource group name
$resourceGroupName = "rg-prometheus-d01"

# Get all virtual machines in the specified resource group
$vmList = Get-AzVM -ResourceGroupName $resourceGroupName

# Stop each virtual machine
foreach ($vm in $vmList) {
    Write-Host "Stopping VM: $($vm.Name)" -ForegroundColor Yellow
    Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Force
    Write-Host "Stopped VM: $($vm.Name)" -ForegroundColor Green
}

Write-Host "All virtual machines in resource group '$resourceGroupName' have been stopped." -ForegroundColor Cyan
