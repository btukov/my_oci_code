###############
# Mgmt access #
###############

# Create set of rule for a load balancer for mgmt for:
# - k8s access
# - mongodb access
# - argocd (443/tcp) *
# - rabbitmq

# * Accessible only to admin/devops

resource "oci_load_balancer_load_balancer" "mgmt" {
  compartment_id = var.oci_compartment_id
  display_name   = "${var.environment}-mgmt"
  shape          = "flexible"
  subnet_ids = [
    module.oci_oke.pub_lb_subnet_id
  ]

  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  is_private = false
  network_security_group_ids = [
    oci_core_network_security_group.public_to_mgmt.id
  ]
  reserved_ips {
    id = oci_core_public_ip.mgmt.id
  }
  shape_details {
    maximum_bandwidth_in_mbps = 2500
    minimum_bandwidth_in_mbps = 1000
  }
}

## Load balancer

resource "oci_load_balancer_backend_set" "mgmt_k8s" {
  health_checker {
    port              = 6443
    protocol          = "TCP" # Could be HTTP or TCP
    retries           = 3
    timeout_in_millis = 1800
    url_path          = "/livez"
  }
  load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
  name             = "${var.environment}-mgmt-k8s"
  policy           = "ROUND_ROBIN"
}

# resource "oci_load_balancer_backend_set" "mgmt_mongo" {
#   health_checker {
#     port = 27017
#     protocol = "TCP" # Could be HTTP or TCP
#     retries = 3
#     timeout_in_millis = 1800
#   }
#   load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
#   name = "${var.environment}-mgmt-mongo"
#   policy = "ROUND_ROBIN"
# }

# resource "oci_load_balancer_backend_set" "mgmt_argocd" {
#   health_checker {
#     port = 443
#     protocol = "HTTP" # Could be HTTP or TCP
#     retries = 3
#     timeout_in_millis = 1800
#   }
#   load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
#   name = "${var.environment}-mgmt-argocd"
#   policy = "ROUND_ROBIN"
# }

# resource "oci_load_balancer_backend_set" "mgmt_rabbitmq" {
#   health_checker {
#     port = 15672
#     protocol = "TCP" # Could be HTTP or TCP
#     retries = 3
#     timeout_in_millis = 1800
#   }
#   load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
#   name = "${var.environment}-mgmt-rabbitmq"
#   policy = "ROUND_ROBIN"
# }

resource "oci_load_balancer_backend" "mgmt_k8s" {
  backendset_name  = oci_load_balancer_backend_set.mgmt_k8s.name
  ip_address       = trimsuffix(module.oci_oke.cluster_endpoints.private_endpoint, ":6443")
  load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
  port             = 6443
  weight           = 1
}

# resource "oci_load_balancer_backend" "mgmt_mongo" {
#   backendset_name = oci_load_balancer_backend_set.mgmt_mongo.name
#   # ip_address = module.oci_instance
#   load_balancer_id = oci_load_balancer_load_balancer.mgmt.id
#   port = 27017
#   weight = 1
# }

resource "oci_load_balancer_listener" "mgmt_k8s" {
  default_backend_set_name = oci_load_balancer_backend_set.mgmt_k8s.name
  load_balancer_id         = oci_load_balancer_load_balancer.mgmt.id
  name                     = "${var.environment}-mgmt-k8s"
  port                     = 6443
  protocol                 = "TCP"
}


## nsg

resource "oci_core_network_security_group" "public_to_mgmt" {
  compartment_id = var.oci_compartment_id
  vcn_id         = module.oci_oke.vcn_id

  display_name = "public_to_management"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
}

resource "oci_core_network_security_group_security_rule" "public_to_k8s" {
  for_each = toset(var.mgmt_access_ip_list)

  network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

  description = "Allow access to k8s' API"
  source      = each.key
  source_type = "CIDR_BLOCK"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "k8s_to_public" {
  for_each = toset(var.mgmt_access_ip_list)

  network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

  description      = "Allow access from k8s' API"
  destination      = each.key
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "k8sapi_to_cp" {
  network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

  description      = "6443 to control-plane NSG"
  destination      = module.oci_oke.control_plane_nsg_id
  destination_type = "NETWORK_SECURITY_GROUP"
  direction        = "EGRESS"
  protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "public_to_mongo" {
  for_each = var.create_mongo_instance ? toset(var.mgmt_access_ip_list) : []
  # for_each = toset(var.mgmt_access_ip_list)

  network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

  description = "Allow access to mongo"
  source      = each.key
  source_type = "CIDR_BLOCK"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 27017
      min = 27017
    }
  }
}

resource "oci_core_network_security_group_security_rule" "mongo_to_public" {
  for_each = var.create_mongo_instance ? toset(var.mgmt_access_ip_list) : []

  network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

  description      = "Allow access from mongo"
  destination      = each.key
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = 27017
      min = 27017
    }
  }
}

# resource "oci_core_network_security_group_security_rule" "public_to_argocd" {
#   for_each = toset(var.mgmt_argocd_access_ip_list)

#   network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

#   description      = "Allow access to argocd"
#   source      = each.key
#   source_type = "CIDR_BLOCK"
#   direction        = "INGRESS"
#   protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
#   stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

#   tcp_options {
#     destination_port_range {
#       max = 443
#       min = 443
#     }
#   }
# }

# resource "oci_core_network_security_group_security_rule" "public_to_rabbitmq" {
#   for_each = toset(var.mgmt_access_ip_list)

#   network_security_group_id = oci_core_network_security_group.public_to_mgmt.id

#   description      = "Allow access to rabbitmq"
#   source      = each.key
#   source_type = "CIDR_BLOCK"
#   direction        = "INGRESS"
#   protocol         = "6"   # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
#   stateless        = false # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

#   tcp_options {
#     destination_port_range {
#       max = 15672
#       min = 15672
#     }
#   }
# }


## control plane NSG from oci_oke module

resource "oci_core_network_security_group_security_rule" "mgmt_to_cp" {
  network_security_group_id = module.oci_oke.control_plane_nsg_id

  description = "Allow access from mgmt to cp"
  source      = oci_core_network_security_group.public_to_mgmt.id
  source_type = "NETWORK_SECURITY_GROUP"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "cp_to_mgmt" {
  network_security_group_id = module.oci_oke.control_plane_nsg_id

  description      = "Allow access from cp to mgmt"
  destination      = oci_core_network_security_group.public_to_mgmt.id
  destination_type = "NETWORK_SECURITY_GROUP"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = 6443
      min = 6443
    }
  }
}

###############
