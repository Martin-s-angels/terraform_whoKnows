variable "subscription_id" {
  description = "The azure subscription ID"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "main-vm"
}

variable "ssh_key_name" {
  type        = string
  description = "name of the file of you keypair"
}

variable "location" {
  description = "The Azure region to deploy resources in. If empty, the script will choose a valid region."
  type        = string
  default     = ""
}