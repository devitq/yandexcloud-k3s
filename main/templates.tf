data "template_file" "main_master_cloud_init" {
  template = file("${path.module}/configs/cloud_init/main_master.yaml")
  vars = {
    k3s_credential_provider_config = base64encode(file("${path.module}/configs/k3s/credentialprovider.yaml"))
    k3s_credential_provider        = base64encode(file("${path.module}/configs/k3s/yc-credential-provider"))
    k3s_dir                        = local.k3s_data_dir
    k3s_token                      = random_password.k3s_token.result
    yc_cloud_id                    = var.cloud_id
  }
}

data "template_file" "master_cloud_init" {
  template = file("${path.module}/configs/cloud_init/master.yaml")
  vars = {
    k3s_credential_provider_config = base64encode(file("${path.module}/configs/k3s/credentialprovider.yaml"))
    k3s_credential_provider        = base64encode(file("${path.module}/configs/k3s/yc-credential-provider"))
    k3s_dir                        = local.k3s_data_dir
    k3s_token                      = random_password.k3s_token.result
    k3s_master_ip                  = local.master_ip
    yc_cloud_id                    = var.cloud_id
  }
}

data "template_file" "worker_cloud_init" {
  template = file("${path.module}/configs/cloud_init/worker.yaml")
  vars = {
    k3s_credential_provider_config = base64encode(file("${path.module}/configs/k3s/credentialprovider.yaml"))
    k3s_credential_provider        = base64encode(file("${path.module}/configs/k3s/yc-credential-provider"))
    k3s_dir                        = local.k3s_data_dir
    k3s_token                      = random_password.k3s_token.result
    k3s_master_ip                  = local.master_ip
    yc_cloud_id                    = var.cloud_id
  }
}

data "template_file" "api_gateway_spec" {
  template = file("${path.module}/configs/api_gateway/spec.yaml")
  vars = {
    bucket_name = yandex_storage_bucket.frontend.bucket
  }
}
