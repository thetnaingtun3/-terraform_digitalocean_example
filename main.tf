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
  count      = 2
  image      = "ubuntu-20-04-x64"
  name       = "testing-${count.index}"
  region     = "sgp1"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    digitalocean_ssh_key.web.id
  ]
  user_data = file("${path.module}/files/user-data.sh")
}

# add ssl 
resource "digitalocean_certificate" "web" {
  name    = "web-certificate"
  type    = "lets_encrypt"
  domains = ["thetnainghtun.me"]
}
resource "digitalocean_loadbalancer" "web" {
  name   = "web-lb"
  region = "sgp1"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 8080
    target_protocol = "http"
    certificate_id  = digitalocean_certificate.web.id
  }
  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }
  droplet_ids = digitalocean_droplet.web.*.id
}



resource "digitalocean_domain" "domain" {
  name = "thetnainghtun.me"

}

resource "digitalocean_record" "main" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.web.ip
}
