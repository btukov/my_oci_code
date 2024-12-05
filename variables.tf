variable "oci_tenancy_ocid" {
  type        = string
  description = "Tenancy oracle cloud identifier"
}

variable "oci_user_ocid" {
  type        = string
  sensitive   = true
  description = "User oracle cloud identifier"
}

variable "oci_private_key" {
  type        = string
  sensitive   = true
  description = "User ssh private key"
}

# variable "oci_private_key_password" {
#   type      = string
#   sensitive = true
#   default   = null
# }

variable "oci_fingerprint" {
  type        = string
  sensitive   = true
  description = "user ssh fingerprint"
}

variable "oci_region" {
  type        = string
  description = "Default region"
}

variable "oci_drp_region" {
  type        = string
  description = "Default region"
}

variable "oci_compartment_parent_id" {
  type        = string
  description = "Compartment parent id. Usually the root on oracle cloud"
}

variable "home_mongo_image_ocid" {
  type    = string
  default = ""
}

variable "bastion_allowlist_ips" {
  type        = list(string)
  description = "Allow list for public IP of the Bastion instance"
}


# mgmt

variable "dev_mgmt_access_ip_list" {
  type        = list(string)
  description = "Allow list for load balancer management access on Dev environment"
}

variable "demo_mgmt_access_ip_list" {
  type        = list(string)
  description = "Allow list for load balancer management access on Demo environment"
}

variable "preprod_mgmt_access_ip_list" {
  type        = list(string)
  description = "Allow list for load balancer management access on Preprod environment"
}

# variable "mgmt_access_ip_list" {
#   type        = list(string)
#   description = "Allow list for load balancer management access"
# }

# variable "mgmt_argocd_access_ip_list" {
#   type        = list(string)
#   description = "Allow list for Argocd specifically"
# }

###


# kafka

variable "dev_kafka_access_ip_list" {
  type        = list(string)
  description = "Allow list for kafka in dev"
}

variable "qa_kafka_access_ip_list" {
  type        = list(string)
  description = "Allow list for kafka in dev"
}

variable "demo_kafka_access_ip_list" {
  type        = list(string)
  description = "Allow list for kafka in demo"
}

# variable "uat_kafka_access_ip_list" {
#   type        = list(string)
#   description = "Allow list for kafka in uat"
# }

variable "preprod_kafka_access_ip_list" {
  type        = list(string)
  description = "Allow list for kafka in preprod"
}

variable "prod_kafka_access_ip_list" {
  type        = list(string)
  description = "Allow list for kafka in prod"
}

###


# web

variable "dev_web_access_ip_list" {
  type        = list(string)
  description = "Allow list for web in dev"
}

variable "qa_web_access_ip_list" {
  type        = list(string)
  description = "Allow list for web in qa"
}

variable "demo_web_access_ip_list" {
  type        = list(string)
  description = "Allow list for web in demo"
}

# variable "uat_web_access_ip_list" {
#   type = list(string)
#   description = "Allow list for web in uat"
# }

variable "preprod_web_access_ip_list" {
  type        = list(string)
  description = "Allow list for web in preprod"
}

variable "prod_web_access_ip_list" {
  type        = list(string)
  description = "Allow list for web in prod"
}

###


# smartsafe

variable "dev_smartsafe_access_ip_list" {
  type        = list(string)
  description = "Allow list for smartsafe in dev"
}

variable "qa_smartsafe_access_ip_list" {
  type        = list(string)
  description = "Allow list for smartsafe in qa"
}

variable "demo_smartsafe_access_ip_list" {
  type        = list(string)
  description = "Allow list for smartsafe in demo"
}

# variable "uat_smartsafe_access_ip_list" {
#   type = list(string)
#   description = "Allow list for smartsafe in uat"
# }

variable "preprod_smartsafe_access_ip_list" {
  type        = list(string)
  description = "Allow list for smartsafe in preprod"
}

variable "prod_smartsafe_access_ip_list" {
  type        = list(string)
  description = "Allow list for smartsafe in prod"
}

###


variable "oke_dev_ssh_private_key" {
  type        = string
  sensitive   = true
  description = "Global ssh private key for Dev environment"
}

variable "oke_dev_ssh_public_key" {
  type        = string
  description = "Global ssh public key for Dev environment"
}

variable "oke_demo_ssh_private_key" {
  type        = string
  sensitive   = true
  description = "Global ssh private key for Demo environment"
}

variable "oke_demo_ssh_public_key" {
  type        = string
  description = "Global ssh public key for Demo environment"
}

variable "oke_preprod_ssh_private_key" {
  type        = string
  sensitive   = true
  description = "Global ssh private key for Preprod environment"
}

variable "oke_preprod_ssh_public_key" {
  type        = string
  description = "Global ssh public key for Preprod environment"
}
