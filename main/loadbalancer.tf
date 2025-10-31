resource "yandex_lb_network_load_balancer" "k8s_lb" {
  name                = "k8s-lb"
  allow_zonal_shift   = true
  deletion_protection = true

  listener {
    name = "kubeapi"
    port = 6443
    external_address_spec {
      address    = yandex_vpc_address.nlb.external_ipv4_address[0].address
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s_main_master.id

    // Verifies that Traefik daeomnset has started on node
    healthcheck {
      name                = "main-master-traefik"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      interval            = 5
      timeout             = 4
      tcp_options {
        port = 80
      }
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.k8s_master.load_balancer[0].target_group_id

    // Verifies that Traefik daeomnset has started on node
    healthcheck {
      name                = "master-instance-group-traefik"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      interval            = 5
      timeout             = 4
      tcp_options {
        port = 80
      }
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.k8s_worker.load_balancer[0].target_group_id

    // Verifies that Traefik daeomnset has started on node
    healthcheck {
      name                = "worker-instance-group-traefik"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      interval            = 5
      timeout             = 4
      tcp_options {
        port = 80
      }
    }
  }
}

resource "yandex_lb_target_group" "k8s_main_master" {
  name      = "k8s-main-master"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.default_ru_central1_d.id
    address   = yandex_compute_instance.k8s_main_master.network_interface.0.ip_address
  }
}
