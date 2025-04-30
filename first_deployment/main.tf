terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50.1"
    }
  }
  required_version = ">= 1.6, < 2.0"

  backend "s3" {
    bucket  = "myterraform"
    key     = "first_deployment/state/state.tfstate"
    region  = "hetzner"      
    endpoints = {
      s3 = "https://nbg1.your-objectstorage.com"
    }
    # Common flags for compatibility:
    skip_credentials_validation = true   # this will skip AWS related validation
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true   # skips checking STS 
    use_path_style              = true   # Ceph-S3 compatibility
    skip_s3_checksum            = true  
    
  }
}

module "hetzner_server_storage_firewall" {
  
  source        = "git::ssh://git@github.com/MarcHoog/MyTerraformModules.git//modules/hetzner/app_S1vF?ref=main"
  
  server_name   = "pilot-server-prod"
  image         = "ubuntu-22.04"         # Use a valid image slug for Hetzner Cloud
  server_type   = "cx31"
  location      = "nbg1"                 # Example location; adjust as needed
  ssh_keys      = ["my-ssh-key"]         # Replace with your registered SSH key names

  volume_name   = "pilot-volume"
  volume_size   = 20                     # Volume size in GB

  firewall_name = "pilot-firewall"
  firewall_description = "Firewall for pilot Hetzner project"
  firewall_in_protocol  = "tcp"
  firewall_in_port      = "80"
  firewall_in_source_ips = ["0.0.0.0/0"]
}
