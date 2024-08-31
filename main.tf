terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
resource "digitalocean_ssh_key" "web" {
  name       = "web app SSH key"
  public_key = file("${path.module}/files/id_rsa.pub")

}


# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  count              = 2
  image              = "ubuntu-20-04-x64"
  name               = "testing-${count.index}"
  region             = "lon1"
  size               = "s-1vcpu-1gb"
  monitoring         = true
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.web.id
  ]
  user_data = file("${path.module}/files/user-data.sh")

}
resource "digitalocean_loadbalancer" "web" {
  name   = "web-lb"
  region = "lon1"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"
  }
  droplet_ids = digitalocean_droplet.web.*.id
}

