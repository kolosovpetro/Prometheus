locals {
  resource_group_name = "rg-prometheus-${var.prefix}"

  private_key_path = "${path.module}/id_rsa"

  provision_script_destination = "/tmp/provision.sh"

  linux_target = {
    name      = "linux-target"
    subdomain = "linux-target"
  }

  windows_target = {
    name      = "windows-target"
    subdomain = "windows-target"
  }


  prometheus_server = {
    name      = "prometheus-server"
    subdomain = "prometheus-server"
  }
}
