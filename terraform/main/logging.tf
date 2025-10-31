resource "yandex_logging_group" "api_gateway" {
  name = "api-gateway"

  retention_period = "336h0m0s"
}
