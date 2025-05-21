terraform {

  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.49.1"
    }
  }


  backend "s3" {
    bucket = "bucketofbuckets"
    key    = "first_deployment/state/state.tfstate"
    region = "digitalocean"
    endpoints = {
      s3 = "https://ams3.digitaloceanspaces.com"
    }
    # Common flags for compatibility:
    skip_credentials_validation = true # this will skip AWS related validation
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true # skips checking STS 
    use_path_style              = true # Ceph-S3 compatibility
    skip_s3_checksum            = true

  }
}

module "hetzner_server" {

  source       = "git::https://github.com/MarcHoog/MyTerraformModules.git?ref=main"
  server_names = ["dingdong"]
  image        = "ubuntu-22.04" # Use a valid image slug for Hetzner Cloud
  server_type  = "cx22"
  location     = "nbg1" # Example location; adjust as needed
  nodes        = 1
  ipv6_enabled = true
}
