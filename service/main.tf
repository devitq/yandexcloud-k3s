resource "yandex_iam_service_account" "sa" {
  name        = "terraform-provider"
  description = "Service account for Terraform"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_key" "sa_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Key for Terraform"
}
