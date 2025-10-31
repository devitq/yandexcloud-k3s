terraform {
  backend "s3" {
    use_lockfile = true
    max_retries  = 5
    retry_mode   = "adaptive"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
