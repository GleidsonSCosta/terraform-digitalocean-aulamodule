terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.52.0"
    }
  }
}

resource "digitalocean_vpc" "wp_net" {
  name     = "wp-network"
  region   = var.region
#   ip_range = "10.10.10.0/24"
}

resource "digitalocean_loadbalancer" "wp_lb" {
  name   = "wp-loadbalancer"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path = "/"
  }

  droplet_ids = digitalocean_droplet.vm_wp[*].id
  
  vpc_uuid = digitalocean_vpc.wp_net.id

}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "vm_wp" {
  image   = "ubuntu-20-04-x64"
  name    = "vw-wp-${count.index + 1}"
  region  = var.region
  size    = "s-2vcpu-2gb"
  vpc_uuid = digitalocean_vpc.wp_net.id
  count = var.qtd_vms

  ssh_keys = [var.vms_ssh]
}

resource "digitalocean_droplet" "vw_nfs" {
  image   = "ubuntu-20-04-x64"
  name    = "vw-nfs"
  region  = var.region
  size    = "s-2vcpu-2gb"
  vpc_uuid = digitalocean_vpc.wp_net.id

  ssh_keys = [var.vms_ssh]
}

# Create a new database cluster
resource "digitalocean_database_db" "wp_database" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = "wp-database"
}

resource "digitalocean_database_cluster" "wp_mysql" {
  name       = "wp-mysql"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
  private_network_uuid = digitalocean_vpc.wp_net.id
}

#Create a new user
resource "digitalocean_database_user" "wp_database_user" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = "wordpress"
}