locals {
  master_ip   = "10.4.0.3"
  master_fqdn = "master."

  k3s_data_dir = "/mnt/k3s"
  k3s_channel  = "stable"
}
