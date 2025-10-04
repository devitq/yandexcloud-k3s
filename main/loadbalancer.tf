# resource "yandex_lb_network_load_balancer" "instance_group_lb" {
#   name                = "instance-group-lb"
#   allow_zonal_shift   = true
#   deletion_protection = true

#   listener {
#     name = "test"
#     port = 8080
#     external_address_spec {
#       # address    = yandex_vpc_address.default.external_ipv4_address[0].address
#       ip_version = "ipv4"
#     }
#   }

#   attached_target_group {
#     target_group_id = yandex_compute_instance_group.default.load_balancer[0].target_group_id

#     healthcheck {
#       name = "http"
#       http_options {
#         port = 8080
#         path = "/ping"
#       }
#     }
#   }
# }

resource "yandex_lb_target_group" "main_master" {
  name      = "main-master"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.default_ru_central1_d.id
    address   = yandex_compute_instance.master.network_interface.0.ip_address
  }
}
