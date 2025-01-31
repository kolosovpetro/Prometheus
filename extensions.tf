module "storage" {
  source                      = "./modules/storage"
  storage_account_name        = "storpromdemo${var.prefix}"
  storage_account_replication = var.storage_account_replication
  storage_account_tier        = var.storage_account_tier
  storage_container_name      = "contvmwin${var.prefix}"
  storage_location            = azurerm_resource_group.public.location
  storage_resource_group_name = azurerm_resource_group.public.name
}

module "windows_target_configure_win_rm" {
  source                            = "./modules/custom-script-extension-windows"
  custom_script_extension_path      = "${path.root}/scripts/Configure-WinRM.ps1"
  custom_script_extension_file_name = "Configure-WinRM.ps1"
  extension_name                    = "ConfigureWinRM"
  storage_account_name              = module.storage.storage_account_name
  storage_container_name            = module.storage.storage_container_name
  virtual_machine_id                = module.target_node_windows.id
}