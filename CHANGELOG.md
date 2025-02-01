# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## v1.0.0 - In Progress

### Changed

- Provisioned 3 virtual machines using Terraform modules
- Windows `WinRM` configured using Azure custom script extensions and Terraform
- Linux target node is provisioned with NGINX using Terraform `file` and `remote-exec` provisioners
- Windows target node is configured with node exporter and IIS using Terraform `file` and `remote-exec` provisioners
- Cloudflare `DNS records` are updated automatically via `PowerShell` using the IP addresses from Terraform state
- Azure custom script extension module for Linux is available too, but not used for the moment
- Whole infrastructure provision is fully automated using `Terraform` and `Azure pipelines`
- SSH keys copied securely inside Azure pipelines
- Fixed file encodings `(BOM characters, EOL)` to make sure consistent provision in Azure pipelines agent and locally
- Setup `sudo add-apt-repository` in non-interactive mode
- Efficient automatic upgrade of Linux system packages using Terraform `remote-exec` provisioners and `Bash`
- Efficient automatic provision of `Prometheus server` using `Bash` and Terraform `remote-exec`
  provisioners
- Efficient automatic provision of Linux `node exporter` for Prometheus using `Bash` and Terraform `remote-exec`
  provisioners
- Added `PowerShell` scripts for quick start and stop of VMs using `Az PowerShell`
