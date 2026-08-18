resource "terraform_data" "k8s_main_master_user_data" {
  input = templatefile("${path.module}/configs/cloud_init/main_master.yaml", {
      k3s_credential_provider_config = base64encode(file("${path.module}/configs/k3s/credentialprovider.yaml"))
      k3s_credential_provider        = base64encode(file("${path.module}/configs/k3s/yc-credential-provider"))
      k3s_dir                        = local.k3s_data_dir
      k3s_token                      = random_password.k3s_token.result
      k3s_fqdn                       = var.cluster_domain
      yc_cloud_id                    = var.cloud_id
    })
}

resource "yandex_compute_instance" "k8s_main_master" {
  name               = "k8s-master"
  hostname           = local.k8s_main_master_fqdn
  description        = "Salt, ansible and kubernetes master, provisions other nodes"
  platform_id        = "standard-v3"
  zone               = "ru-central1-d"
  service_account_id = yandex_iam_service_account.k8s_main_master_vm_sa.id

  allow_recreate            = true
  allow_stopping_for_update = true

  labels = {
    salt    = "master"
    ansible = "master"
  }

  lifecycle {
    ignore_changes = [
      hostname, boot_disk[0].initialize_params[0].image_id
    ]
    replace_triggered_by = [
      terraform_data.k8s_main_master_user_data
    ]
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
      description = "Boot disk for K8S main master"
      block_size  = 4096
      size        = 10
      type        = "network-hdd"
    }
    auto_delete = true
    mode        = "READ_WRITE"
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.k8s_main_master_disk.id
    device_name = "data"
    mode        = "READ_WRITE"
    auto_delete = false
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.default_ru_central1_d.id
    ip_address = local.k8s_main_master_ip
    ipv4       = true
    nat        = true
    dns_record {
      fqdn = "${local.k8s_main_master_fqdn}."
      ptr  = true
      ttl  = 10
    }
  }
  network_acceleration_type = "standard"

  metadata = {
    enable-oslogin        = true
    serial-port-enable    = 1
    install-unified-agent = 0
    user-data = terraform_data.k8s_main_master_user_data.output
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
