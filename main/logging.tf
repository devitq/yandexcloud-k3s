resource "yandex_logging_group" "default" {
  name = "default"

  retention_period = "336h0m0s"
}
