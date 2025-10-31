resource "yandex_api_gateway" "frontend" {
  name              = "frontend"
  description       = "API Gateway for frontend"
  execution_timeout = "300"

  connectivity {
    network_id = yandex_vpc_network.default.id
  }

  custom_domains {
    fqdn           = local.final_frontend_domain
    certificate_id = yandex_cm_certificate.default.id
  }

  log_options {
    log_group_id = yandex_logging_group.api_gateway.id
    min_level    = "INFO"
  }

  spec = data.template_file.frontend_api_gateway_spec.rendered
}
