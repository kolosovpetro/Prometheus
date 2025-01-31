output "prometheus_master_public_ip" {
  value = module.prometheus_master_node_linux.public_ip_address
}

output "linux_target_public_ip" {
  value = module.target_node_linux.public_ip_address
}

output "windows_target_public_ip" {
  value = module.target_node_windows.public_ip_address
}