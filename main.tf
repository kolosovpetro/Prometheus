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
  subnet_name                       = module.network.targets_subnet_name
  vm_name                           = "vm-${local.linux_target.name}-${var.prefix}"
  vm_size                           = var.vm_size
  vnet_name                         = module.network.vnet_name
  public_ip_name                    = "pip-${local.linux_target.name}-${var.prefix}"
  subnet_id                         = module.network.target_subnet_id
  nsg_name                          = "nsg-${local.linux_target.name}-${var.prefix}"
}

module "windows_target_vm" {
  source                      = "./modules/windows-vm"
  ip_configuration_name       = "ipc-${local.windows_target.name}-${var.prefix}"
  network_interface_name      = "nic-${local.windows_target.name}-${var.prefix}"
  network_security_group_id   = "nsg-${local.windows_target.name}-${var.prefix}"
  os_profile_admin_password   = var.os_profile_admin_password
  os_profile_admin_username   = var.os_profile_admin_username
  os_profile_computer_name    = "vm-${local.windows_target.name}-${var.prefix}"
  public_ip_name              = "pip-${local.windows_target.name}-${var.prefix}"
  resource_group_location     = azurerm_resource_group.public.location
  resource_group_name         = azurerm_resource_group.public.name
  storage_image_reference_sku = "2022-Datacenter"
  storage_os_disk_name        = "osdisk-${local.windows_target.name}-${var.prefix}"
  subnet_id                   = module.network.target_subnet_id
  vm_name                     = "vm-${local.windows_target.name}-${var.prefix}"
  vm_size                     = var.vm_size
}