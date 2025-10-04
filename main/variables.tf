variable "folder_id" {}

variable "cloud_id" {}

variable "resources_prefix" {
  type    = string
  default = ""
}

variable "domain" {
  description = "Domain to issue TLS certificates for with Let's Encrypt"
  type        = string
}

variable "ssh_public_key_path" {
  description = "This public key will be placed on all nodes"
  type        = string
}
