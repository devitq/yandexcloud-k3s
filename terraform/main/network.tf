resource "yandex_vpc_network" "default" {
  name        = "default"
  description = "Default network"
  labels = {
    default = true
  }
}

resource "yandex_vpc_default_security_group" "default" {
  network_id  = yandex_vpc_network.default.id
  description = "Default security group for default network"

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_subnet" "default_ru_central1_a" {
  name        = "default-ru-central1-a"
  description = "Default subnet for ru-central1-a"

  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.default.id
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = "ru-central1-a"
}

resource "yandex_vpc_subnet" "default_ru_central1_b" {
  name        = "default-ru-central1-b"
  description = "Default subnet for ru-central1-b"

  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.default.id
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-b"
}

resource "yandex_vpc_subnet" "default_ru_central1_d" {
  name        = "default-ru-central1-d"
  description = "Default subnet for ru-central1-d"

  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.default.id
  v4_cidr_blocks = ["10.4.0.0/16"]
  zone           = "ru-central1-d"
}

resource "yandex_vpc_address" "nlb" {
  name                = "nlb"
  description         = "External IP address for network lb"
  deletion_protection = true

  external_ipv4_address {
    zone_id = "ru-central1-d"
  }
}

resource "yandex_vpc_gateway" "default" {
  name        = "default"
  description = "Default Gateway for all instances"
  labels      = {}

  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "default" {
  name       = "default"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.default.id
  }
}
