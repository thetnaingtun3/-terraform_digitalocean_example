terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


resource "digitalocean_ssh_key" "web" {
  name       = "Terraform Testing"
  public_key = file("${path.module}/user_file/id_rsa.pub")
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "testing"
  region = "lon1"
  size   = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys = [
    digitalocean_ssh_key.web.id,
  ]

user_data =  file("${path.module}/user_file/index.sh")
}

# Create a new domain
resource "digitalocean_domain" "domain" {
  name       = "thetnainghtun.me"
}


# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "main" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.web.ipv4_address
}
