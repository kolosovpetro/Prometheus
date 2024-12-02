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
}

module "windows_target_vm" {
  source                      = "./modules/windows-vm"
  ip_configuration_name       = "ipc-${local.windows_target.name}-${var.prefix}"
  network_interface_name      = "nic-${local.windows_target.name}-${var.prefix}"
  network_security_group_id   = azurerm_network_security_group.public.id
  os_profile_admin_password   = var.os_profile_admin_password
  os_profile_admin_username   = var.os_profile_admin_username
  os_profile_computer_name    = "vm-win-target"
  public_ip_name              = "pip-${local.windows_target.name}-${var.prefix}"
  resource_group_location     = azurerm_resource_group.public.location
  resource_group_name         = azurerm_resource_group.public.name
  storage_image_reference_sku = "2022-Datacenter"
  storage_os_disk_name        = "osdisk-${local.windows_target.name}-${var.prefix}"
  subnet_id                   = module.network.target_subnet_id
  vm_name                     = "vm-${local.windows_target.name}-${var.prefix}"
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

module "configure_windows_target_win_rm" {
  source                                = "./modules/custom-script-extension"
  custom_script_extension_absolute_path = "E:\\RiderProjects\\03_TERRAFORM_PROJECTS\\prometheus-learning\\scripts\\Configure-Ansible-Host.ps1"
  custom_script_extension_file_name     = "Configure-Ansible-Host.ps1"
  extension_name                        = "ConfigureAnsibleHost"
  storage_account_name                  = module.storage.storage_account_name
  storage_container_name                = module.storage.storage_container_name
  virtual_machine_id                    = module.windows_target_vm.id
}

module "configure_prom_server_ansible" {
  source                                = "./modules/linux-custom-script-extension"
  custom_script_extension_absolute_path = "E:\\RiderProjects\\03_TERRAFORM_PROJECTS\\prometheus-learning\\scripts\\install_ansible.sh"
  custom_script_extension_file_name     = "install_ansible.sh"
  extension_name                        = "InstallAnsible"
  storage_account_name                  = module.storage.storage_account_name
  storage_container_name                = module.storage.storage_container_name
  virtual_machine_id                    = module.prometheus_server_vm.id
}

module "configure_linux_target" {
  source                                = "./modules/linux-custom-script-extension"
  custom_script_extension_absolute_path = "E:\\RiderProjects\\03_TERRAFORM_PROJECTS\\prometheus-learning\\scripts\\install_nginx.sh"
  custom_script_extension_file_name     = "install_nginx.sh"
  extension_name                        = "InstallNginx"
  storage_account_name                  = module.storage.storage_account_name
  storage_container_name                = module.storage.storage_container_name
  virtual_machine_id                    = module.linux_target_vm.id
}