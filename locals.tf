locals {
  
  resource_group_name = "rg-prom-${var.prefix}"

  linux_target = {
    name = "linux-target"
  }

  windows_target = {
    name = "windows-target"
  }


  prometheus_server = {
    name = "prom-server"
  }
}
