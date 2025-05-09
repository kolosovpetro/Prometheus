##########################################################################
# PROMETHEUS MASTER NODE (LINUX)
##########################################################################

output "master_public_ip" {
  value = module.prometheus_master_node_linux.public_ip
}

output "master_ssh_command" {
  value = "ssh razumovsky_r@${module.prometheus_master_node_linux.public_ip}"
}

output "master_configure_command" {
  value = "ssh -o StrictHostKeyChecking=no razumovsky_r@${module.prometheus_master_node_linux.public_ip} \"wget -qO- https://raw.githubusercontent.com/kolosovpetro/Prometheus/refs/heads/master/scripts/Install-AlertManager-Config.sh | sudo bash\""
}

output "master_prometheus_ui_url" {
  value = "http://${module.prometheus_master_node_linux.public_ip}:9090"
}

output "master_alert_manager_url" {
  value = "http://${module.prometheus_master_node_linux.public_ip}:9093"
}

output "master_nginx_http_url" {
  value = "http://${module.prometheus_master_node_linux.public_ip}:80"
}

output "master_grafana_url" {
  value = "http://${module.prometheus_master_node_linux.public_ip}:3000/login"
}

##########################################################################
# PROMETHEUS TARGET NODE (LINUX)
##########################################################################

output "linux_target_public_ip" {
  value = module.target_node_linux.public_ip
}

output "linux_target_ssh_command" {
  value = "ssh razumovsky_r@${module.target_node_linux.public_ip}"
}

output "linux_target_node_exporter_url" {
  value = "http://${module.target_node_linux.public_ip}:9100/metrics"
}

output "linux_target_http_url" {
  value = "http://${module.target_node_linux.public_ip}:80"
}

##########################################################################
# PROMETHEUS TARGET NODE (WINDOWS)
##########################################################################

output "windows_target_public_ip" {
  value = module.target_node_windows.public_ip
}

output "windows_node_exporter_url" {
  value = "http://${module.target_node_windows.public_ip}:9182/metrics"
}

