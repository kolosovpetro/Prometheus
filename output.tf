output "prometheus_master_public_ip" {
  value = module.prometheus_master_node_linux.public_ip
}

output "prometheus_master_ssh_command" {
  value = "ssh razumovsky_r@${module.prometheus_master_node_linux.public_ip}"
}

output "linux_target_public_ip" {
  value = module.target_node_linux.public_ip
}

output "linux_target_ssh_commend" {
  value = "ssh razumovsky_r@${module.target_node_linux.public_ip}"
}

output "windows_target_public_ip" {
  value = module.target_node_windows.public_ip
}

output "windows_target_ssh_command" {
  value = "ssh razumovsky_r@${module.target_node_windows.public_ip}"
}