variable "oci_compartment_id" {
  type        = string
  description = "ID of the compartment to create where we will deploy everything"
}

variable "oci_tenancy_ocid" {
  type        = string
  description = "Tenancy oracle cloud identifier"
}

variable "home_region" {
  type        = string
  description = "The tenancy's home region. Required to perform identity operations"
}

variable "region" {
  type        = string
  description = "Region where the cluster should be deployed"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Name of the environment. Preferably all lowwercase"
}

variable "k8s_version" {
  type        = string
  default     = "v1.26.2"
  description = "Kubernetes cluster version. Note that the node doesn't update by themselves and you should create another pool to 'upgrade' it"
}

variable "k8s_private_key" {
  type        = string
  description = "Global ssh private key"
}

variable "k8s_public_key" {
  type        = string
  description = "Global ssh public key"
}

variable "cluster_name" {
  type        = string
  default     = null
  nullable    = true
  description = "Optional. Set a cluster name. By default: customer-platform-<ENVIRONMENT NAME>"
}

variable "bastion_allowed_cidrs" {
  type        = list(string)
  description = "Allow list for public IP of the Bastion instance"
}

variable "bastion_public_ip" {
  type        = string
  default     = null
  nullable    = true
  description = "Hardcode the public IP. !!! Never tested"
}

variable "operator_private_ip" {
  type        = string
  default     = null
  nullable    = true
  description = "Hardcode the private IP"
}

variable "install_metric_server" {
  type        = bool
  default     = false
  description = "Whether to deploy the Kubernetes Metrics Server Helm chart. See https://github.com/kubernetes-sigs/metrics-server"
}

variable "worker_shape" {
  type        = map(any)
  default     = { "boot_volume_size" : 50, "memory" : 8, "ocpus" : 4, "shape" : "VM.Standard.E4.Flex" }
  description = "Default worker shape on pool creation"
}

variable "worker_pools" {
  # type = map({
  #   map({
  #     autoscale        = optional(bool, false)
  #     boot_volume_size = optional(number)
  #     drain            = optional(bool, false)
  #     memory           = optional(number)
  #     node_labels      = optional(map)
  #     ocpus            = optional(number)
  #     size             = number
  #     shape            = optional(string)
  #   })
  # })
  type        = map(any)
  default     = {}
  description = "Worker pool definition. Here you can define the workers shape and node labels for example"
}

variable "internal_data_cidr_block" {
  type        = string
  default     = null
  nullable    = true
  description = "cidr block for the internal-data subne"
}

variable "create_mongo_instance" {
  type        = bool
  default     = false
  description = "Define if a mongodb instance should be create or not"
}

variable "mongo_image_ocid" {
  type        = string
  default     = ""
  description = "mongodb instance source image ocid"
}

variable "mongo_memory" {
  type        = number
  default     = 16
  nullable    = true
  description = "mongodb memory size in GB"
}

variable "mongo_cpu" {
  type        = number
  default     = 8
  nullable    = true
  description = "mongodb vcpu number"
}

variable "mongo_private_ip" {
  type        = string
  default     = null
  nullable    = true
  description = "Hardcode the private IP"
}

variable "mongo_user_data" {
  type        = string
  default     = null
  nullable    = true
  description = "templatefile of user-data file"
}

variable "mongo_volume_backup_policy" {
  type        = string
  default     = "disabled"
  description = "Choose between default backup policies : gold, silver, bronze. Use disabled to affect no backup policy on the Boot Volume"
}

variable "cluster_type" {
  type        = string
  default     = "basic"
  description = "type of cluster : basic or enhanced"
}

# mgmt

variable "mgmt_access_ip_list" {
  type        = list(string)
  description = "Allow list to access managmeent IP"
}

# variable "mgmt_argocd_access_ip_list" {
#   type        = list(string)
#   description = "Allow list to access Argocd"
# }

variable "mgmt_private_ip" {
  type     = string
  default  = null
  nullable = true
}

###


variable "loadbalancer_nsgs" {
  type = list(object({
    name              = string
    access_ip_list    = list(string)
    loadbalancer_ocid = string
    port              = number
  }))
  default = []
}


# kafka

variable "kafka_private_ip" {
  type     = string
  default  = null
  nullable = true
}


# web

variable "web_private_ip" {
  type     = string
  default  = null
  nullable = true
}


# smartsafe

variable "smartsafe_private_ip" {
  type     = string
  default  = null
  nullable = true
}
