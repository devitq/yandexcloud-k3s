resource "yandex_compute_instance_group" "master" {
  name                = "master"
  description         = "Masters instance group for Kubernetes cluster"
  service_account_id  = yandex_iam_service_account.instance_group_sa.id
  deletion_protection = true
  labels = {
    "kubernetes" = "cluster"
    "role"       = "control-plane"
  }

  instance_template {
    name = "master-{instance.index_in_zone}-{instance.zone_id}"
    hostname = "master-{instance.index_in_zone}.{instance.zone_id}"
    labels = {
      "instance-group" = "master"
      "kubernetes"     = "control-plane"
      "salt"           = "minion"
    }
    service_account_id = yandex_iam_service_account.instance_group_vm_sa.id

    platform_id = "standard-v3"
    resources {
      core_fraction = 50
      cores         = 2
      gpus          = 0
      memory        = 4
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
      device_name = "data"
      initialize_params {
        description = "Data disk"
        size        = 20
        type        = "network-hdd"
      }
      mode = "READ_WRITE"
    }

    network_interface {
      network_id = yandex_vpc_network.default.id
      subnet_ids = [
        yandex_vpc_subnet.default_ru_central1_a.id,
        yandex_vpc_subnet.default_ru_central1_b.id,
        yandex_vpc_subnet.default_ru_central1_d.id,
      ]
      nat = false
    }
    network_settings {
      type = "STANDARD"
    }

    metadata_options {
      aws_v1_http_endpoint = 1
      aws_v1_http_token    = 2
      gce_http_endpoint    = 1
      gce_http_token       = 1
    }
    metadata = {
      enable-oslogin        = true
      serial-port-enable    = 1
      install-unified-agent = 0
      user-data             = data.template_file.master_cloud_init.rendered
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }
  deploy_policy {
    max_creating     = 3
    max_deleting     = 3
    max_expansion    = 0
    max_unavailable  = 1
    startup_duration = 300
    strategy         = "proactive"
  }

  load_balancer {
    target_group_name            = "master-instance-group"
    target_group_description     = "Load balancer target group for k8s masters"
    max_opening_traffic_duration = 600
    ignore_health_checks         = true
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 2
    timeout             = 1

    tcp_options {
      port = 6443
    }
  }
  max_checking_health_duration = 600

  depends_on = [
    yandex_compute_instance.master,
    yandex_iam_service_account.instance_group_sa,
    yandex_resourcemanager_folder_iam_member.instance_group_sa_compute_editor,
    yandex_resourcemanager_folder_iam_member.instance_group_sa_lb_editor
  ]
}

resource "yandex_compute_instance_group" "worker" {
  name                = "worker"
  description         = "Workers instance group for Kubernetes cluster"
  service_account_id  = yandex_iam_service_account.instance_group_sa.id
  deletion_protection = true
  labels = {
    "kubernetes" = "cluster"
    "role"       = "worker"
  }

  instance_template {
    name = "worker-{instance.index_in_zone}-{instance.zone_id}"
    hostname = "worker-{instance.index_in_zone}.{instance.zone_id}.internal"
    labels = {
      "instance-group" = "worker"
      "kubernetes"     = "worker"
      "salt"           = "minion"
    }
    service_account_id = yandex_iam_service_account.instance_group_vm_sa.id

    platform_id = "standard-v3"
    resources {
      core_fraction = 50
      cores         = 2
      gpus          = 0
      memory        = 2
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
      device_name = "data"
      initialize_params {
        description = "Data disk"
        size        = 20
        type        = "network-hdd"
      }
      mode = "READ_WRITE"
    }

    network_interface {
      network_id = yandex_vpc_network.default.id
      subnet_ids = [
        yandex_vpc_subnet.default_ru_central1_a.id,
        yandex_vpc_subnet.default_ru_central1_b.id,
        yandex_vpc_subnet.default_ru_central1_d.id,
      ]
      nat = false
    }
    network_settings {
      type = "STANDARD"
    }

    metadata_options {
      aws_v1_http_endpoint = 1
      aws_v1_http_token    = 2
      gce_http_endpoint    = 1
      gce_http_token       = 1
    }
    metadata = {
      enable-oslogin        = true
      serial-port-enable    = 1
      install-unified-agent = 0
      user-data             = data.template_file.worker_cloud_init.rendered
    }
  }

  scale_policy {
    fixed_scale {
      size = 0
    }
  }
  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  }
  deploy_policy {
    max_creating     = 3
    max_deleting     = 3
    max_expansion    = 0
    max_unavailable  = 1
    startup_duration = 300
    strategy         = "proactive"
  }

  load_balancer {
    target_group_name            = "worker-instance-group"
    target_group_description     = "Load balancer target group for k8s workers"
    max_opening_traffic_duration = 600
    ignore_health_checks         = true
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 2
    timeout             = 1

    tcp_options {
      port = 80
    }
  }
  max_checking_health_duration = 600

  depends_on = [
    yandex_compute_instance.master,
    yandex_iam_service_account.instance_group_sa,
    yandex_resourcemanager_folder_iam_member.instance_group_sa_compute_editor,
    yandex_resourcemanager_folder_iam_member.instance_group_sa_lb_editor
  ]
}
