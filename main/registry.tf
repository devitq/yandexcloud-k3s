resource "yandex_container_registry" "default" {
  name = "default"

  labels = {}
}

resource "yandex_container_registry_iam_binding" "default_push" {
  registry_id = yandex_container_registry.default.id
  role        = "container-registry.images.pusher"

  members = [
    "serviceAccount:${yandex_iam_service_account.registry_push_sa.id}",
  ]
}

resource "yandex_container_registry_iam_binding" "default_pull" {
  registry_id = yandex_container_registry.default.id
  role        = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.registry_pull_sa.id}",
  ]
}

resource "yandex_container_registry_iam_binding" "instance_group_vm_sa_pull" {
  registry_id = yandex_container_registry.default.id
  role        = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.instance_group_vm_sa.id}",
  ]
}
