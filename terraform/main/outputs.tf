output "registry_data" {
  value = {
    url = "cr.yandex/${yandex_container_registry.default.id}"
  }
}

output "frontend_api_gateway_data" {
  value = {
    domain = yandex_api_gateway.frontend.domain
  }
}

output "registry_push_sa_key" {
  value = jsonencode({
    id                 = yandex_iam_service_account_key.registry_push_sa_key.id
    service_account_id = yandex_iam_service_account_key.registry_push_sa_key.service_account_id
    created_at         = yandex_iam_service_account_key.registry_push_sa_key.created_at
    key_algorithm      = yandex_iam_service_account_key.registry_push_sa_key.key_algorithm
    public_key         = yandex_iam_service_account_key.registry_push_sa_key.public_key
    private_key        = yandex_iam_service_account_key.registry_push_sa_key.private_key
  })
  sensitive = true
}

output "registry_pull_sa_key" {
  value = jsonencode({
    id                 = yandex_iam_service_account_key.registry_pull_sa_key.id
    service_account_id = yandex_iam_service_account_key.registry_pull_sa_key.service_account_id
    created_at         = yandex_iam_service_account_key.registry_pull_sa_key.created_at
    key_algorithm      = yandex_iam_service_account_key.registry_pull_sa_key.key_algorithm
    public_key         = yandex_iam_service_account_key.registry_pull_sa_key.public_key
    private_key        = yandex_iam_service_account_key.registry_pull_sa_key.private_key
  })
  sensitive = true
}

output "frontend_push_sa_key" {
  value = jsonencode({
    id                 = yandex_iam_service_account_key.frontend_push_sa_key.id
    service_account_id = yandex_iam_service_account_key.frontend_push_sa_key.service_account_id
    created_at         = yandex_iam_service_account_key.frontend_push_sa_key.created_at
    key_algorithm      = yandex_iam_service_account_key.frontend_push_sa_key.key_algorithm
    public_key         = yandex_iam_service_account_key.frontend_push_sa_key.public_key
    private_key        = yandex_iam_service_account_key.frontend_push_sa_key.private_key
  })
  sensitive = true
}

output "lets_encrypt_challenges" {
  value = yandex_cm_certificate.default.challenges
}
