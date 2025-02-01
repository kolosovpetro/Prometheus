locals {
  linux_target      = "linux-target"
  windows_target    = "windows-target"
  prometheus_master = "prometheus-master"
}

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

##########################################################################
# MASTER NODE (LINUX)
##########################################################################

module "prometheus_master_node_linux" {
  source                            = "./modules/azure-linux-vm-key-auth"
  ip_configuration_name             = "ipc-${local.prometheus_master}-${var.prefix}"
  network_interface_name            = "nic-${local.prometheus_master}-${var.prefix}"
  os_profile_admin_public_key_path  = "${path.root}/id_rsa.pub"
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
  provision_script_destination = "/tmp/provision_master.sh"
  provision_script_path        = "${path.root}/scripts/Install-Nginx.sh"
  vm_public_ip_address         = module.prometheus_master_node_linux.public_ip_address

  depends_on = [
    module.prometheus_master_node_linux,
    azurerm_network_security_group.public
  ]
}

##########################################################################
# TARGET NODE (LINUX)
##########################################################################

module "target_node_linux" {
  source                            = "./modules/azure-linux-vm-key-auth"
  ip_configuration_name             = "ipc-${local.linux_target}-${var.prefix}"
  network_interface_name            = "nic-${local.linux_target}-${var.prefix}"
  os_profile_admin_public_key_path  = "${path.root}/id_rsa.pub"
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
  provision_script_destination = "/tmp/provision-exporter.sh"
  provision_script_path        = "${path.root}/scripts/Install-Nginx.sh"
  vm_public_ip_address         = module.target_node_linux.public_ip_address

  depends_on = [
    module.target_node_linux,
    azurerm_network_security_group.public
  ]
}

##########################################################################
# TARGET NODE (WINDOWS)
##########################################################################

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

module "storage" {
  source                      = "./modules/storage"
  storage_account_name        = "storpromdemo${var.prefix}"
  storage_account_replication = var.storage_account_replication
  storage_account_tier        = var.storage_account_tier
  storage_container_name      = "contvmwin${var.prefix}"
  storage_location            = azurerm_resource_group.public.location
  storage_resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_role_assignment" "example" {
  scope                = module.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = "89ab0b10-1214-4c8f-878c-18c3544bb547"
}

module "custom_script_extension_configure_win_rm" {
  source                            = "./modules/custom-script-extension-windows"
  custom_script_extension_path      = "${path.root}/scripts/Configure-WinRM.ps1"
  custom_script_extension_file_name = "Configure-WinRM.ps1"
  extension_name                    = "ConfigureWinRM"
  storage_account_name              = module.storage.storage_account_name
  storage_container_name            = module.storage.storage_container_name
  virtual_machine_id                = module.target_node_windows.id

  depends_on = [
    azurerm_network_security_group.public
  ]
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
    module.custom_script_extension_configure_win_rm
  ]
}