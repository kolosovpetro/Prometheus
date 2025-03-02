ipconfig /flushdns

$urls = @(
    "prometheus-master.razumovsky.me",
    "linux-target.razumovsky.me",
    "windows-target.razumovsky.me"
)

foreach ($url in $urls) {
    Write-Host "Running nslookup for $url"
    nslookup $url
    Write-Host "`n"
}
