resource "azurerm_resource_group" "public" {
  location = var.resource_group_location
  name     = local.resource_group_name
}

module "network" {
  source                  = "./modules/network"
  resource_group_location = azurerm_resource_group.public.location
  resource_group_name     = azurerm_resource_group.public.name
  targets_subnet_name     = "target-subnet-${var.prefix}"
  vnet_name               = "vnet-${var.prefix}"
  server_subnet_name      = "server-subnet-${var.prefix}"
}

module "prometheus_server_vm" {
  source                            = "./modules/ubuntu-vm-public-key-auth"
  ip_configuration_name             = "ipc-${local.prometheus_server.name}-${var.prefix}"
  network_interface_name            = "nic-${local.prometheus_server.name}-${var.prefix}"
  os_profile_admin_public_key_path  = var.os_profile_admin_public_key_path
  os_profile_admin_username         = var.os_profile_admin_username
  os_profile_computer_name          = "vm-${local.prometheus_server.name}-${var.prefix}"
  resource_group_location           = azurerm_resource_group.public.location
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = var.storage_image_reference_offer
  storage_image_reference_publisher = var.storage_image_reference_publisher
  storage_image_reference_sku       = var.storage_image_reference_sku
  storage_image_reference_version   = var.storage_image_reference_version
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_name              = "osdisk-${local.prometheus_server.name}-${var.prefix}"
  vm_name                           = "vm-${local.prometheus_server.name}-${var.prefix}"
  vm_size                           = var.vm_size
  public_ip_name                    = "pip-${local.prometheus_server.name}-${var.prefix}"
  subnet_id                         = module.network.prom_server_subnet_id
  network_security_group_id         = azurerm_network_security_group.public.id
  private_key_path                  = local.private_key_path
  provision_script_destination      = local.provision_script_destination
  provision_script_path             = "${path.module}/scripts/Install-Linux-Prometheus-Server.sh"
}

module "linux_target_vm" {
  source                            = "./modules/ubuntu-vm-public-key-auth"
  ip_configuration_name             = "ipc-${local.linux_target.name}-${var.prefix}"
  network_interface_name            = "nic-${local.linux_target.name}-${var.prefix}"
  os_profile_admin_public_key_path  = var.os_profile_admin_public_key_path
  os_profile_admin_username         = var.os_profile_admin_username
  os_profile_computer_name          = "vm-${local.linux_target.name}-${var.prefix}"
  resource_group_location           = azurerm_resource_group.public.location
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = var.storage_image_reference_offer
  storage_image_reference_publisher = var.storage_image_reference_publisher
  storage_image_reference_sku       = var.storage_image_reference_sku
  storage_image_reference_version   = var.storage_image_reference_version
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_name              = "osdisk-${local.linux_target.name}-${var.prefix}"
  vm_name                           = "vm-${local.linux_target.name}-${var.prefix}"
  vm_size                           = var.vm_size
  public_ip_name                    = "pip-${local.linux_target.name}-${var.prefix}"
  subnet_id                         = module.network.target_subnet_id
  network_security_group_id         = azurerm_network_security_group.public.id
  private_key_path                  = local.private_key_path
  provision_script_destination      = local.provision_script_destination
  provision_script_path             = "${path.module}/scripts/Install-Linux-Node-Exporter.sh"
}

module "windows_target_vm" {
  source                       = "./modules/windows-vm"
  ip_configuration_name        = "ipc-${local.windows_target.name}-${var.prefix}"
  network_interface_name       = "nic-${local.windows_target.name}-${var.prefix}"
  network_security_group_id    = azurerm_network_security_group.public.id
  os_profile_admin_password    = var.os_profile_admin_password
  os_profile_admin_username    = var.os_profile_admin_username
  os_profile_computer_name     = "vm-win-target"
  public_ip_name               = "pip-${local.windows_target.name}-${var.prefix}"
  resource_group_location      = azurerm_resource_group.public.location
  resource_group_name          = azurerm_resource_group.public.name
  storage_image_reference_sku  = "2022-Datacenter"
  storage_os_disk_name         = "osdisk-${local.windows_target.name}-${var.prefix}"
  subnet_id                    = module.network.target_subnet_id
  vm_name                      = "vm-${local.windows_target.name}-${var.prefix}"
  vm_size                      = var.vm_size
}

resource "null_resource" "provision_win_vm" {
  depends_on = [
    module.windows_target_vm,
    module.windows_target_configure_win_rm,
    azurerm_network_security_group.public
  ]

  provisioner "file" {
    source      = "${path.module}/scripts/Install-Windows-Exporter.ps1"
    destination = "C:\\Temp\\Install-Windows-Exporter.ps1"

    connection {
      type     = "winrm"
      user     = var.os_profile_admin_username
      password = var.os_profile_admin_password
      host     = module.windows_target_vm.public_ip_address
      port     = 5986
      https    = true
      timeout  = "2m"
      use_ntlm = true
      insecure = true
    }
  }

  provisioner "remote-exec" {
    connection {
      type     = "winrm"
      user     = var.os_profile_admin_username
      password = var.os_profile_admin_password
      host     = module.windows_target_vm.public_ip_address
      port     = 5986
      https    = true
      timeout  = "2m"
      use_ntlm = true
      insecure = true
    }

    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File C:\\Temp\\Install-Windows-Exporter.ps1"
    ]
  }
}