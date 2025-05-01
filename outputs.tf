output "wp_lb_ip" {
  value =  digitalocean_loadbalancer.wp_lb.ip
  description = "IP do Load Balancer"
}


output "wp_wp_ips" {
  value =  digitalocean_droplet.vm_wp[*].ipv4_address
  description = "IPs das máquinas Wordpress"
}

output "wp_nfs_ips" {
  value =  digitalocean_droplet.vw_nfs.ipv4_address
  description = "IP da máquina NFS"
}

output "wp_db_user" {
  value = digitalocean_database_user.wp_database_user.name
  description = "Nome do usuário do banco de dados"
}

output "wp_db_pass" {
  value = digitalocean_database_user.wp_database_user.password
  description = "Senha do usuário do banco de dados"
  sensitive = true
}


