terraform {

  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.49.1"
    }
  }


  backend "s3" {
  }
}

module "hetzner_server" {

  source       = "git::https://github.com/MarcHoog/MyTerraformModules.git//modules/hetzner/server?ref=main"
  server_names = ["MyK3s"]
  image        = "241168872"
  server_type  = "cx22"
  location     = "nbg1" # Example location; adjust as needed
  nodes        = 1
  ssh_keys     = ["bubble"]
  ipv4_enabled = true
}
