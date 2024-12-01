locals {

  resource_group_name = "rg-prom-${var.prefix}"
  domain_name         = "razumovsky.me"

  linux_target = {
    name      = "linux-target"
    subdomain = "linux-target"
  }

  windows_target = {
    name      = "windows-target"
    subdomain = "windows-target"
  }


  prometheus_server = {
    name      = "prom-server"
    subdomain = "prom-server"
  }
}
