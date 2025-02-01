# Connect-AzAccount
$ErrorActionPreference = "Stop"

Update-AzConfig -DefaultSubscriptionForLogin $env:KOLOSOVP94_MPN_SUB_ID

$SecureClientSecret = ConvertTo-SecureString -String $env:KOLOSOVP94_MPN_SUB_CLIENT_SECRET `
    -AsPlainText -Force;$connectCreds=[PSCredential]::new($env:KOLOSOVP94_MPN_SUB_CLIENT_ID, $SecureClientSecret);

Connect-AzAccount -ServicePrincipal -Credential $connectCreds -Tenant $env:KOLOSOVP94_MPN_SUB_TENANT_ID

Set-AzContext -SubscriptionId $env:KOLOSOVP94_MPN_SUB_ID
# Define the resource group name
$resourceGroupName = "rg-prometheus-d01"

$ErrorActionPreference = "Stop"

# Get all virtual machines in the specified resource group
$vmList = Get-AzVM -ResourceGroupName $resourceGroupName

# Start each virtual machine
foreach ($vm in $vmList) {
    Write-Host "Starting VM: $($vm.Name)" -ForegroundColor Yellow
    Start-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name
    Write-Host "Started VM: $($vm.Name)" -ForegroundColor Green
}

Write-Host "All virtual machines in resource group '$resourceGroupName' have been started." -ForegroundColor Cyan