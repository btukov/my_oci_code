#######
# OKE #
#######

resource "oci_core_network_security_group" "egress_to_public" {
  compartment_id = var.oci_compartment_id
  vcn_id         = module.oci_oke.vcn_id

  display_name = "private_network_access_to_public_filtered"
}

resource "oci_core_network_security_group_security_rule" "allow_https_tcp_egress" {
  network_security_group_id = oci_core_network_security_group.egress_to_public.id

  description      = "Allow HTTPS (443) TCP egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_http_tcp_egress" {
  network_security_group_id = oci_core_network_security_group.egress_to_public.id

  description      = "Allow HTTP (80) TCP egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_udp_dns_egress" {
  network_security_group_id = oci_core_network_security_group.egress_to_public.id

  description      = "Allow 53 DNS UDP egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "17"  # UDP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  udp_options {
    destination_port_range {
      max = 53
      min = 53
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_udp_ntp_egress" {
  network_security_group_id = oci_core_network_security_group.egress_to_public.id

  description      = "Allow 53 NTP UDP egress"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "17"  # UDP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  udp_options {
    destination_port_range {
      max = 123
      min = 123
    }
  }
}

resource "oci_core_network_security_group" "ssh_to_internal_data" {
  compartment_id = var.oci_compartment_id
  vcn_id         = module.oci_oke.vcn_id

  display_name = "ssh_into_internal_data_subnet"
}

resource "oci_core_network_security_group_security_rule" "allow_ssh_into_internal_data_subnet" {
  count = var.create_mongo_instance ? 1 : 0

  network_security_group_id = oci_core_network_security_group.ssh_to_internal_data.id

  description      = "Allow ssh TCP egress inside internal_data subnet"
  destination      = oci_core_subnet.internal_data[0].cidr_block
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

# See https://github.com/oracle-terraform-modules/terraform-oci-oke
module "oci_oke" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "5.0.0-beta.4"


  ### Common
  tenancy_id     = var.oci_tenancy_ocid
  compartment_id = var.oci_compartment_id
  # create_vcn = false
  vcn_name           = "oke-${var.environment}-vcn"
  home_region        = var.home_region # The tenancy's home region. Required to perform identity operations
  region             = var.region
  kubernetes_version = var.k8s_version # Doesn't update the pools. You will need to delete and recreate the pools to "upgrade" them
  # TODO
  ssh_private_key = var.k8s_private_key # Optionally base64-encoded
  # ssh_private_key_path = ""
  ssh_public_key = var.k8s_public_key # The contents of the SSH public key file, optionally base64-encoded. Used to allow login for workers/bastion/operator with corresponding private key
  # ssh_public_key_path = ""
  assign_dns = true


  ### Cluster
  create_cluster = true
  # TODO: Make some test with the "enhanced" version
  cluster_type            = var.cluster_type
  cluster_name            = var.cluster_name == null ? "customer-platform-${var.environment}" : var.cluster_name
  control_plane_is_public = false
  # control_plane_nsg_ids = []
  load_balancers          = "public"
  preferred_load_balancer = "public"
  create_iam_resources    = true
  # create_nsgs             = true
  subnets = {
    bastion  = { newbits = 13, dns_label = "bastion" }
    operator = { newbits = 13, dns_label = "operator" }
    cp       = { newbits = 13 }
    pub_lb   = { newbits = 11 }
    workers  = { newbits = 2 }
    pods     = { newbits = 2 }
  }
  nsgs = {
    bastion  = { create = "always" }
    operator = { create = "always" }
    cp       = { create = "always" }
    int_lb   = { create = "auto" }
    pub_lb   = { create = "always" }
    workers  = { create = "always" }
    pods     = { create = "auto" }
    fss      = { create = "auto" }
  }
  allow_node_port_access = false


  ### Bastion
  create_bastion        = true
  bastion_allowed_cidrs = var.bastion_allowed_cidrs
  bastion_is_public     = true
  bastion_public_ip     = var.bastion_public_ip
  bastion_nsg_ids = [
    oci_core_network_security_group.egress_to_public.id,
    oci_core_network_security_group.ssh_to_internal_data.id
  ]
  bastion_upgrade = true
  # TODO: Wait until the module manage properly another user than opc
  # bastion_user = "devops"


  ### Operator
  # See https://github.com/oracle-terraform-modules/terraform-oci-operator
  # See https://github.com/oracle-terraform-modules/terraform-oci-oke/blob/main/docs/instructions.adoc#using-the-operator-host
  create_operator          = true
  operator_install_helm    = true
  operator_install_k9s     = true
  operator_install_kubectx = true
  # TODO: Wait until the module manage properly another user than opc
  # operator_user = "devops"
  operator_upgrade    = false
  operator_shape      = { "boot_volume_size" : 50, "memory" : 4, "ocpus" : 2, "shape" : "VM.Standard.E4.Flex" }
  operator_private_ip = var.operator_private_ip


  ### Autoscaling
  # cluster_autoscaler_helm_values = {} # See https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template
  # cluster_autoscaler_install = false # See https://github.com/kubernetes/autoscaler Note that is not supported by Oracle


  # See https://github.com/kubernetes-sigs/metrics-server
  metrics_server_install = var.install_metric_server
  # metrics_server_helm_values = {}


  ### WAF
  # See https://github.com/oracle-terraform-modules/terraform-oci-oke/blob/main/docs/instructions.adoc#17-enabling-waf
  # N.B. This paraemeter need to be actived only after the cluster is created. That means that it needs to be run two times with "terraform apply"
  # Not needed if the cluster is in private mode
  enable_waf = false # Whether to enable WAF monitoring of load balancers


  ### Gatekeeper. See https://github.com/open-policy-agent/gatekeeper
  # gatekeeper_helm_values = {}
  # gatekeeper_install = true


  ### Workers
  allow_worker_internet_access = true # To permit to get container images from external registries e.g. hub.docker.com
  allow_worker_ssh_access      = false
  worker_is_public             = false
  worker_pool_size             = 3
  worker_shape                 = var.worker_shape
  worker_pools                 = var.worker_pools


  providers = {
    oci.home = oci.home
  }
}

##############
