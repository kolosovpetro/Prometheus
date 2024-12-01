variable "resource_group_location" {
  type        = string
  description = "Resource group location"
}

variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine."
}

variable "storage_image_reference_publisher" {
  type        = string
  description = "The publisher of the image used to create the virtual machine."
}

variable "storage_image_reference_offer" {
  type        = string
  description = "Specifies the offer of the platform image or marketplace image used to create the virtual machine."
}

variable "storage_image_reference_sku" {
  type        = string
  description = "Specifies the SKU of the platform image or marketplace image used to create the virtual machine."
}

variable "storage_image_reference_version" {
  type        = string
  description = "Specifies the version of the platform image or marketplace image used to create the virtual machine."
}

variable "storage_os_disk_caching" {
  type        = string
  description = "Specifies the caching requirements for the OS disk."
}

variable "storage_os_disk_create_option" {
  type        = string
  description = "Specifies how the virtual machine should be created."
}

variable "storage_os_disk_managed_disk_type" {
  type        = string
  description = "Specifies the storage account type for the managed disk."
}

variable "os_profile_admin_username" {
  type        = string
  description = "Specifies the name of the administrator account."
}

variable "os_profile_admin_public_key_path" {
  type        = string
  description = "Specifies the public key of the administrator account."
}

variable "os_profile_admin_password" {
  type        = string
  description = "Specifies the password of the administrator account."
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}

variable "storage_account_replication" {
  type        = string
  description = "Specifies the replication type for this storage account."
}

variable "storage_account_tier" {
  type        = string
  description = "Specifies the tier to use for this storage account."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
