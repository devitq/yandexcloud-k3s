resource "yandex_compute_disk" "k8s_main_master_disk" {
  name        = "k8s_main_master_disk"
  description = "Disk for K8S main master persistent storage"

  zone       = "ru-central1-d"
  size       = 10
  type       = "network-hdd"
  block_size = 4096

  allow_recreate = false
}
