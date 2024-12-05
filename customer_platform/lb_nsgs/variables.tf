variable "lb_ocid" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oke_vcn_id" {
  type = string
}

variable "oke_worker_nsg_id" {
  type = string
}

variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "access_ip_list" {
  type = list(string)
}

variable "port" {
  type = number
}
