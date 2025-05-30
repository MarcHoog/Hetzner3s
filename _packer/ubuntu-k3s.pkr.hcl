packer {
  required_plugins {
    hcloud = {
      version = ">= 1.6.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

source "hcloud" "k3s" {
  image       = "ubuntu-22.04"
  server_type = "cx22"
  location    = "fsn1"
  ssh_username = "root"


  snapshot_name   = "Ubuntu-22.04 x86 k3s Single Node"
  snapshot_labels = {
    type    = "k3s",
    os      = "ubuntu-22.04",
    arch    = "x86",
    creator = "hcloud-k3s"
  }
}

build {
  name = "k3s-hetzner"

  sources = ["source.hcloud.k3s"]

  provisioner "shell" {
    inline = [
      "curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_START=true sh -",
      "systemctl enable k3s",
    ]
  }
  

  provisioner "shell" {
    inline = [
      "rm -f /etc/machine-id",
      "truncate -s 0 /var/log/wtmp /var/log/btmp || true",
    ]
  }

  provisioner "shell" {
    inline = [
        "rm -rf /etc/rancher/k3s /var/lib/rancher/k3s",
        "rm -f /var/lib/cloud/instances/*/sem/config_scripts_user",
    ]
    }

}
