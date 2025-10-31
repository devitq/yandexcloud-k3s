variable "folder_id" {}

variable "cloud_id" {}

variable "domain" {
  description = "Domain to issue TLS certificates for with Let's Encrypt"
  type        = string
}

variable "frontend_domain" {
  description = "Domain to serve frontend from (must equal domain or *.domain), default: domain"
  type        = string
  default     = null
}

variable "frontend_develop_domain" {
  description = "Domain to serve develop version of frontend from (must equal domain or *.domain), default: dev.domain"
  type        = string
  default     = null
}
