##########################################################################
# RESOURCE GROUP
##########################################################################

resource "azurerm_resource_group" "public" {
  location = "northeurope"
  name     = "rg-prometheus-${var.prefix}"
}

##########################################################################
# VNET AND SUBNET
##########################################################################

resource "azurerm_virtual_network" "public" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_subnet" "internal" {
  name                 = "subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.0/26"]
}

##########################################################################
# PROMETHEUS MASTER NODE (LINUX)
##########################################################################

module "prometheus_master_node_linux" {
  source                           = "github.com/kolosovpetro/AzureLinuxVMTerraform.git//modules/ubuntu-vm-key-auth-custom-image?ref=master"
  custom_image_resource_group_name = "rg-packer-images-linux"
  custom_image_sku                 = "azure-ubuntu-monitoring-master"
  ip_configuration_name            = "ipc-master-${var.prefix}"
  network_interface_name           = "nic-master-${var.prefix}"
  os_profile_admin_public_key      = file("${path.root}/id_rsa.pub")
  os_profile_admin_username        = "razumovsky_r"
  os_profile_computer_name         = "vm-master-${var.prefix}"
  public_ip_name                   = "pip-master-${var.prefix}"
  resource_group_location          = azurerm_resource_group.public.location
  resource_group_name              = azurerm_resource_group.public.name
  storage_os_disk_name             = "osdisk-master-${var.prefix}"
  subnet_id                        = azurerm_subnet.internal.id
  vm_name                          = "vm-master-${var.prefix}"
  network_security_group_id        = azurerm_network_security_group.public.id
}

##########################################################################
# PROMETHEUS TARGET NODE (LINUX)
##########################################################################

module "target_node_linux" {
  source                           = "github.com/kolosovpetro/AzureLinuxVMTerraform.git//modules/ubuntu-vm-key-auth-custom-image?ref=master"
  custom_image_resource_group_name = "rg-packer-images-linux"
  custom_image_sku                 = "azure-ubuntu-monitoring-target"
  ip_configuration_name            = "ipc-linux-target-${var.prefix}"
  network_interface_name           = "nic-linux-target-${var.prefix}"
  os_profile_admin_public_key      = file("${path.root}/id_rsa.pub")
  os_profile_admin_username        = "razumovsky_r"
  os_profile_computer_name         = "vm-linux-target-${var.prefix}"
  public_ip_name                   = "pip-linux-target-${var.prefix}"
  resource_group_location          = azurerm_resource_group.public.location
  resource_group_name              = azurerm_resource_group.public.name
  storage_os_disk_name             = "osdisk-linux-target-${var.prefix}"
  subnet_id                        = azurerm_subnet.internal.id
  vm_name                          = "vm-linux-target-${var.prefix}"
  network_security_group_id        = azurerm_network_security_group.public.id
}

##########################################################################
# PROMETHEUS TARGET NODE (WINDOWS)
##########################################################################

module "target_node_windows" {
  source                      = "github.com/kolosovpetro/AzureWindowsVMTerraform.git//modules/windows-vm-custom-image?ref=master"
  ip_configuration_name       = "ipc-win-target-${var.prefix}"
  network_interface_name      = "nic-win-target-${var.prefix}"
  network_security_group_id   = azurerm_network_security_group.public.id
  os_profile_admin_password   = trimspace(file("${path.root}/password.txt"))
  os_profile_admin_username   = "razumovsky_r"
  os_profile_computer_name    = "vm-win-${var.prefix}"
  public_ip_name              = "pip-win-target-${var.prefix}"
  location                    = azurerm_resource_group.public.location
  resource_group_name         = azurerm_resource_group.public.name
  custom_image_resource_group = "rg-packer-images-win"
  custom_image_sku            = "windows-server2022-v2"
  storage_os_disk_name        = "osdisk-win-target-${var.prefix}"
  subnet_id                   = azurerm_subnet.internal.id
  vm_name                     = "vm-win-target-${var.prefix}"
}
