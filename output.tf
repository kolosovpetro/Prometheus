output "prometheus_server_data" {
  value = {
    ip_address = module.prometheus_server_vm.public_ip_address
    fqdn       = "${local.prometheus_server.subdomain}.razumovsky.me"
    http_link  = "http://${local.prometheus_server.subdomain}.razumovsky.me"
  }
}

output "linux_target_data" {
  value = {
    ip_address = module.linux_target_vm.public_ip_address
    fqdn       = "${local.linux_target.subdomain}.razumovsky.me"
    http_link  = "http://${local.linux_target.subdomain}.razumovsky.me"
  }
}

output "windows_target_data" {
  value = {
    ip_address = module.windows_target_vm.public_ip_address
    fqdn       = "${local.windows_target.subdomain}.razumovsky.me"
    http_link  = "http://${local.windows_target.subdomain}.razumovsky.me"
  }
}