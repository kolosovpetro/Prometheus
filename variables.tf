variable "resource_group_location" {
  type        = string
  description = "Resource group location"
}

variable "prefix" {
  type        = string
  description = "Prefix for all resources"
  default = "d01"
}

variable "os_profile_admin_username" {
  type        = string
  description = "Specifies the name of the administrator account."
}

variable "os_profile_admin_password" {
  type        = string
  description = "Specifies the password of the administrator account."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
