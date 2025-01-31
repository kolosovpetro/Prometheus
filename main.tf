resource "azurerm_resource_group" "public" {
  location = var.resource_group_location
  name     = "rg-prometheus-${var.prefix}"
}

module "network" {
  source                  = "./modules/network"
  resource_group_location = azurerm_resource_group.public.location
  resource_group_name     = azurerm_resource_group.public.name
  targets_subnet_name     = "target-subnet-${var.prefix}"
  vnet_name               = "vnet-${var.prefix}"
  server_subnet_name      = "server-subnet-${var.prefix}"
}

module "prometheus_master_node_linux" {
  source                            = "./modules/azure-linux-vm-key-auth"
  ip_configuration_name             = "ipc-${local.prometheus_master}-${var.prefix}"
  network_interface_name            = "nic-${local.prometheus_master}-${var.prefix}"
  os_profile_admin_public_key_path  = var.os_profile_admin_public_key_path
  os_profile_admin_username         = var.os_profile_admin_username
  os_profile_computer_name          = "vm-${local.prometheus_master}-${var.prefix}"
  resource_group_location           = azurerm_resource_group.public.location
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = var.storage_image_reference_offer
  storage_image_reference_publisher = var.storage_image_reference_publisher
  storage_image_reference_sku       = var.storage_image_reference_sku
  storage_image_reference_version   = var.storage_image_reference_version
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_name              = "osdisk-${local.prometheus_master}-${var.prefix}"
  vm_name                           = "vm-${local.prometheus_master}-${var.prefix}"
  vm_size                           = var.vm_size
  public_ip_name                    = "pip-${local.prometheus_master}-${var.prefix}"
  subnet_id                         = module.network.prom_server_subnet_id
  network_security_group_id         = azurerm_network_security_group.public.id
}

module "provision_prometheus_master_node" {
  source                       = "./modules/provisioner-linux"
  os_profile_admin_username    = var.os_profile_admin_username
  private_key_path             = "${path.root}/id_rsa"
  provision_script_destination = "/tmp/provision.sh"
  provision_script_path        = "${path.root}/scripts/Install-Linux-Prometheus-Server.sh"
  vm_public_ip_address         = module.prometheus_master_node_linux.public_ip_address
}

module "target_node_linux" {
  source                            = "./modules/azure-linux-vm-key-auth"
  ip_configuration_name             = "ipc-${local.linux_target}-${var.prefix}"
  network_interface_name            = "nic-${local.linux_target}-${var.prefix}"
  os_profile_admin_public_key_path  = var.os_profile_admin_public_key_path
  os_profile_admin_username         = var.os_profile_admin_username
  os_profile_computer_name          = "vm-${local.linux_target}-${var.prefix}"
  resource_group_location           = azurerm_resource_group.public.location
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = var.storage_image_reference_offer
  storage_image_reference_publisher = var.storage_image_reference_publisher
  storage_image_reference_sku       = var.storage_image_reference_sku
  storage_image_reference_version   = var.storage_image_reference_version
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_name              = "osdisk-${local.linux_target}-${var.prefix}"
  vm_name                           = "vm-${local.linux_target}-${var.prefix}"
  vm_size                           = var.vm_size
  public_ip_name                    = "pip-${local.linux_target}-${var.prefix}"
  subnet_id                         = module.network.target_subnet_id
  network_security_group_id         = azurerm_network_security_group.public.id
}

module "provision_target_node_linux" {
  source                       = "./modules/provisioner-linux"
  os_profile_admin_username    = var.os_profile_admin_username
  private_key_path             = "${path.root}/id_rsa"
  provision_script_destination = "/tmp/provision.sh"
  provision_script_path        = "${path.root}/scripts/Install-Linux-Node-Exporter.sh"
  vm_public_ip_address         = module.prometheus_master_node_linux.public_ip_address
}

module "target_node_windows" {
  source                      = "./modules/azure-windows-vm"
  ip_configuration_name       = "ipc-${local.windows_target}-${var.prefix}"
  network_interface_name      = "nic-${local.windows_target}-${var.prefix}"
  network_security_group_id   = azurerm_network_security_group.public.id
  os_profile_admin_password   = var.os_profile_admin_password
  os_profile_admin_username   = var.os_profile_admin_username
  os_profile_computer_name    = "vm-win-target"
  public_ip_name              = "pip-${local.windows_target}-${var.prefix}"
  resource_group_location     = azurerm_resource_group.public.location
  resource_group_name         = azurerm_resource_group.public.name
  storage_image_reference_sku = "2022-Datacenter"
  storage_os_disk_name        = "osdisk-${local.windows_target}-${var.prefix}"
  subnet_id                   = module.network.target_subnet_id
  vm_name                     = "vm-${local.windows_target}-${var.prefix}"
  vm_size                     = var.vm_size
}

module "provision_windows_node_exporter" {
  source                       = "./modules/provisioner-windows"
  os_profile_admin_username    = var.os_profile_admin_username
  os_profile_admin_password    = var.os_profile_admin_password
  provision_script_destination = "C:\\Temp\\Install-Windows-Exporter.ps1"
  provision_script_path        = "${path.root}/scripts/Install-Windows-Exporter.ps1"
  public_ip_address            = module.target_node_windows.public_ip_address

  depends_on = [
    module.target_node_windows,
    module.windows_target_configure_win_rm
  ]
}