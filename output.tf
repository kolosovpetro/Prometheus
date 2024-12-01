output "prometheus_server_data" {
  value = {
    ip_address = module.prometheus_server_vm.public_ip_address
  }
}