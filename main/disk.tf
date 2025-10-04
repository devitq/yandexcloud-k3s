resource "yandex_compute_disk" "master_disk" {
  name        = "master_disk"
  description = "Disk for master persistent storage"

  zone       = "ru-central1-d"
  size       = 10
  type       = "network-hdd"
  block_size = 4096

  allow_recreate = false
}

resource "yandex_compute_disk" "worker_minecraft_disk" {
  name        = "worker_minecraft_disk"
  description = "Disk for worker persistent storage"

  zone       = "ru-central1-d"
  size       = 20
  type       = "network-ssd"
  block_size = 4096

  allow_recreate = false
}
