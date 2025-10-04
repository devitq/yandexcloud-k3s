resource "yandex_compute_instance" "master" {
  name               = "master"
  hostname           = "master"
  description        = "Salt, ansible and kubernetes master, provisions other nodes"
  platform_id        = "standard-v3"
  zone               = "ru-central1-d"
  service_account_id = yandex_iam_service_account.master_vm_sa.id

  allow_recreate            = true
  allow_stopping_for_update = true

  labels = {
    salt    = "master"
    ansible = "master"
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
    gpus          = 0
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_2404.id
      description = "Boot disk for master"
      block_size  = 4096
      size        = 10
      type        = "network-hdd"
    }
    auto_delete = true
    mode        = "READ_WRITE"
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.master_disk.id
    device_name = "data"
    mode        = "READ_WRITE"
    auto_delete = false
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default_ru_central1_d.id
    ip_address = local.master_ip
    ipv4       = true
    nat        = true
    dns_record {
      fqdn = local.master_fqdn
      ptr  = true
      ttl  = 10
    }
  }
  network_acceleration_type = "standard"

  metadata = {
    enable-oslogin        = true
    serial-port-enable    = 1
    install-unified-agent = 0
    user-data             = data.template_file.main_master_cloud_init.rendered
  }

  metadata_options {
    aws_v1_http_endpoint = 1
    aws_v1_http_token    = 2
    gce_http_endpoint    = 1
    gce_http_token       = 1
  }
  placement_policy {
    host_affinity_rules       = []
    placement_group_partition = 0
  }
}

resource "yandex_compute_instance" "worker-minecraft" {
  name        = "worker-minecraft"
  hostname    = "worker-minecraft.internal"
  description = "Worker node for Kubernetes cluster"
  labels = {
    "kubernetes" = "worker"
    "role"       = "worker"
    "salt"       = "minion"
  }

  service_account_id = yandex_iam_service_account.instance_group_vm_sa.id
  platform_id        = "standard-v3"
  zone               = "ru-central1-d"

  resources {
    core_fraction = 100
    cores         = 2
    gpus          = 0
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_2404.id
      description = "Boot disk"
      size        = 10
      type        = "network-hdd"
    }
    mode = "READ_WRITE"
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.worker_minecraft_disk.id
    device_name = "data"
    mode        = "READ_WRITE"
    auto_delete = false
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default_ru_central1_d.id
    ipv4       = true
    nat        = false
  }
  network_acceleration_type = "standard"


  metadata = {
    enable-oslogin        = true
    serial-port-enable    = 1
    install-unified-agent = 0
    user-data             = data.template_file.worker_cloud_init.rendered
  }

  metadata_options {
    aws_v1_http_endpoint = 1
    aws_v1_http_token    = 2
    gce_http_endpoint    = 1
    gce_http_token       = 1
  }
  placement_policy {
    host_affinity_rules       = []
    placement_group_partition = 0
  }

  depends_on = [
    yandex_compute_instance.master,
    yandex_iam_service_account.instance_group_vm_sa
  ]
}
