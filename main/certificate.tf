resource "yandex_cm_certificate" "default" {
  name                = "default"
  description         = "Default certificate for all resources"
  deletion_protection = true

  domains = tolist([var.domain, "*.${var.domain}"])

  managed {
    challenge_type = "DNS_CNAME"
  }
}
