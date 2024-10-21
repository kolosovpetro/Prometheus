resource "azurerm_resource_group" "public" {
  location = var.resource_group_location
  name     = "rg-prometheus-${var.prefix}"
}

module "network" {
  source                  = "./modules/network"
  resource_group_location = azurerm_resource_group.public.location
  resource_group_name     = azurerm_resource_group.public.name
  subnet_name             = "subnet-${var.prefix}"
  vnet_name               = "vnet-${var.prefix}"
}

module "ubuntu-vm-public-key-auth" {
  for_each                          = local.environments
  source                            = "./modules/ubuntu-vm-public-key-auth"
  ip_configuration_name             = "ipc-${each.value.name}-${var.prefix}"
  network_interface_name            = "nic-${each.value.name}-${var.prefix}"
  os_profile_admin_public_key_path  = var.os_profile_admin_public_key_path
  os_profile_admin_username         = var.os_profile_admin_username
  os_profile_computer_name          = "vm-${each.value.name}-${var.prefix}"
  resource_group_location           = azurerm_resource_group.public.location
  resource_group_name               = azurerm_resource_group.public.name
  storage_image_reference_offer     = var.storage_image_reference_offer
  storage_image_reference_publisher = var.storage_image_reference_publisher
  storage_image_reference_sku       = var.storage_image_reference_sku
  storage_image_reference_version   = var.storage_image_reference_version
  storage_os_disk_caching           = var.storage_os_disk_caching
  storage_os_disk_create_option     = var.storage_os_disk_create_option
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  storage_os_disk_name              = "osdisk-${each.value.name}-${var.prefix}"
  subnet_name                       = module.network.subnet_name
  vm_name                           = "vm-${each.value.name}-${var.prefix}"
  vm_size                           = var.vm_size
  vnet_name                         = module.network.vnet_name
  public_ip_name                    = "pip-${each.value.name}-${var.prefix}"
  subnet_id                         = module.network.subnet_id
  nsg_name                          = "nsg-${each.value.name}-${var.prefix}"

  depends_on = [
    azurerm_resource_group.public,
    module.network.subnet_name,
    module.network.vnet_name,
    module.network.subnet_id
  ]
}