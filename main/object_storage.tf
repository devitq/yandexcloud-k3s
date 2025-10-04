resource "yandex_storage_bucket" "frontend" {
  bucket                = var.domain
  default_storage_class = "STANDARD"
  force_destroy         = false
  max_size              = 104857600

  anonymous_access_flags {
    config_read = false
    list        = true
    read        = true
  }
}

resource "yandex_storage_bucket" "frontend_develop" {
  bucket                = "dev.${var.domain}"
  default_storage_class = "STANDARD"
  force_destroy         = false
  max_size              = 104857600

  anonymous_access_flags {
    config_read = false
    list        = true
    read        = true
  }
}

resource "yandex_storage_bucket_iam_binding" "frontend_bucket_push" {
  bucket = yandex_storage_bucket.frontend.bucket
  role   = "storage.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.frontend_push_sa.id}",
  ]
}
