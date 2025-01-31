output "prometheus_server_data" {
  value = {
    ip_address = module.prometheus_master_node_linux.public_ip_address
    fqdn       = "${local.prometheus_master}.razumovsky.me"
    http_link  = "http://${local.prometheus_master}.razumovsky.me"
  }
}

output "linux_target_data" {
  value = {
    ip_address = module.target_node_linux.public_ip_address
    fqdn       = "${local.linux_target}.razumovsky.me"
    http_link  = "http://${local.linux_target}.razumovsky.me"
  }
}

output "windows_target_data" {
  value = {
    ip_address = module.target_node_windows.public_ip_address
    fqdn       = "${local.windows_target}.razumovsky.me"
    http_link  = "http://${local.windows_target}.razumovsky.me"
  }
}