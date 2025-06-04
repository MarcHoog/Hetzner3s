terraform {

  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.49.1"
    }
  }


  backend  "s3" {
  }
}

module "singleNodeK3s" {
  source       = "git::https://github.com/MarcHoog/MyTerraformModules.git//modules/hetzner/server?ref=main"
  server_name = "boeing747"
  image        = "ubuntu-24.04"
  server_type  = "cx22"
  location     = "nbg1" # Example location; adjust as needed
  ssh_keys     = ["bubble", "ansible"]
  ipv4_enabled = true
  labels = {
    "k3s": "controller"
    "arch": "x86"
  }
}

#module "MasterNodesK3s" {
#  source       = "git::https://github.com/MarcHoog/MyTerraformModules.git//modules/hetzner/server?ref=main"
#  server_names = ["MyK3s"]
#  image        = "Ubuntu22.04"
#  server_type  = "cx22"
#  location     = "nbg1" # Example location; adjust as needed
#  nodes        = 1
#  ssh_keys     = ["bubble"]
#  ipv4_enabled = true
#}


#module "AgentNodesK3s" {
#  source       = "git::https://github.com/MarcHoog/MyTerraformModules.git//modules/hetzner/server?ref=main"
# server_names = ["MyK3s"]
#  image        = "Ubuntu22.04"
#  server_type  = "cx22"
#  location     = "nbg1" # Example location; adjust as needed
#  nodes        = 1
#  ssh_keys     = ["bubble"]
#  ipv4_enabled = true
#}
