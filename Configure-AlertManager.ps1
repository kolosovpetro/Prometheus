Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$configureCommand = $( terraform output -raw "master_configure_command" )

Write-Host "Command is: $configureCommand" -ForegroundColor Yellow

Write-Host "Executing $configureCommand"

Invoke-Expression $configureCommand

Write-Host "Alert manager configured successfully!" -ForegroundColor Green

exit 0
