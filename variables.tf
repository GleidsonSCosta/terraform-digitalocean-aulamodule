variable "region" {
  type = string
}

variable "qtd_vms" {
  type = number
  description = "Número de máquinas"

  validation {
    condition = var.qtd_vms > 1
    error_message = "O números mínimo de máquinas é 2."
  }
}

variable "vms_ssh" {
  type = string
  description = "Chave ssh para acessar as VMs"
}