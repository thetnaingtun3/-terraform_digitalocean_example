# Terraform DigitalOcean Infrastructure

This project uses Terraform to manage and automate the deployment of infrastructure on DigitalOcean. Terraform is an Infrastructure as Code (IaC) tool that allows you to define and provision data center infrastructure using a high-level configuration language.

## Prerequisites

Before starting, ensure you have the following prerequisites:

1. **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads.html).
2. **SSH Key**: An SSH key pair is required to securely access your servers. Make sure you have a public key at `~/.ssh/id_rsa.pub`.
3. **DigitalOcean Token**: Obtain a DigitalOcean API token from your DigitalOcean account. This token is necessary for authenticating API requests.

### Set Up Environment Variable

Export your DigitalOcean API token as an environment variable:

```sh
export DIGITALOCEAN_TOKEN="your_digitalocean_token"
```

### Copy Local Device's SSH Key into Files

```sh
cp ~/.ssh/id_rsa.pub files
```

```sh
terraform init 
```

```sh
terraform fmt 
```

```sh
terraform plan
```

```sh
terraform apply
```

```sh
 tail -f /var/log/cloud-init-output.log
```

