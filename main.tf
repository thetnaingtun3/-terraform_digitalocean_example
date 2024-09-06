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
  # count = 1
  image = "ubuntu-24-04-x64"
  name  = "testing"
  # name       = "testing-${count.index}"
  region = "sgp1"
  # size       = "s-1vcpu-1gb"
  size       = "s-2vcpu-4gb"
  monitoring = true
  ssh_keys = [
    digitalocean_ssh_key.web.id
  ]
  user_data = file("${path.module}/files/user-data.sh")
  # user_data = <<-EOF
  #             #!/bin/bash
  #             apt-get update
  #             apt-get install -y nginx
  #             systemctl start nginx
  #             systemctl enable nginx
  #             curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  #             apt-get install -y nodejs

  #             $(cat ${path.module}/files/user-data.sh")
  #             EOF 

}


resource "digitalocean_domain" "domain" {
  name = "thetnainghtun.me"

}

resource "digitalocean_record" "main" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.web.ipv4_address
}

# what is next 


