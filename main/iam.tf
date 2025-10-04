resource "yandex_iam_service_account" "instance_group_sa" {
  name        = "instance-group-sa"
  description = "Service account for instance group"
}

resource "yandex_resourcemanager_folder_iam_member" "instance_group_sa_compute_editor" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.instance_group_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "instance_group_sa_lb_editor" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.instance_group_sa.id}"
}

resource "yandex_iam_service_account" "instance_group_vm_sa" {
  name        = "instance-group-vm-sa"
  description = "Service account for instance group vm"
}

resource "yandex_iam_service_account_iam_binding" "instance_group_vm_sa_admin" {
  service_account_id = yandex_iam_service_account.instance_group_vm_sa.id
  role               = "admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.instance_group_sa.id}",
  ]
}

resource "yandex_iam_service_account" "master_vm_sa" {
  name        = "master-vm-sa"
  description = "Service account for master vm"
}

resource "yandex_compute_instance_iam_binding" "master_vm_sa_editor" {
  instance_id = yandex_compute_instance.master.id
  role        = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.master_vm_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "master_vm_sa_viewer" {
  folder_id = var.folder_id
  role      = "compute.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.master_vm_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "master_vm_sa_oslogin" {
  folder_id = var.folder_id
  role      = "compute.osAdminLogin"
  member    = "serviceAccount:${yandex_iam_service_account.master_vm_sa.id}"
}

resource "yandex_iam_service_account" "registry_push_sa" {
  name        = "registry-push-sa"
  description = "Service account for CI"
}

resource "yandex_iam_service_account_key" "registry_push_sa_key" {
  service_account_id = yandex_iam_service_account.registry_push_sa.id
  description        = "Key for CI"
}

resource "yandex_iam_service_account" "registry_pull_sa" {
  name        = "registry-pull-sa"
  description = "Service account for CD"
}

resource "yandex_iam_service_account_key" "registry_pull_sa_key" {
  service_account_id = yandex_iam_service_account.registry_pull_sa.id
  description        = "Key for CD"
}

resource "yandex_iam_service_account" "frontend_push_sa" {
  name        = "frontend-push-sa"
  description = "Service account for frontend CD"
}

resource "yandex_iam_service_account_key" "frontend_push_sa_key" {
  service_account_id = yandex_iam_service_account.frontend_push_sa.id
  description        = "Key for frontend CD"
}
