# Requires Install-Module -Name CloudflareDnsTools -Scope AllUsers

$zoneName = "razumovsky.me"

$newDnsEntriesHashtable = @{ }

$newDnsEntriesHashtable["prometheus-master.$zoneName"] = $( terraform output -raw master_public_ip )
$newDnsEntriesHashtable["linux-target.$zoneName"] = $( terraform output -raw linux_target_public_ip )
$newDnsEntriesHashtable["windows-target.$zoneName"] = $( terraform output -raw windows_target_public_ip )

Set-CloudflareDnsRecord `
    -ApiToken $env:CLOUDFLARE_API_KEY `
    -ZoneName $zoneName `
    -NewDnsEntriesHashtable $newDnsEntriesHashtable
