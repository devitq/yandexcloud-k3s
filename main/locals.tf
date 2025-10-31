locals {
  k8s_main_master_ip   = "10.4.0.3"
  k8s_main_master_fqdn = "master.k8s.internal"

  k3s_data_dir = "/mnt/k3s"
  k3s_channel  = "stable"

  final_frontend_domain         = var.frontend_domain != null ? var.frontend_domain : var.domain
  final_frontend_develop_domain = var.frontend_develop_domain != null ? var.frontend_develop_domain : "dev.${var.domain}"
}
