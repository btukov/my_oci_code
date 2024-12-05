data "oci_load_balancer_backend_sets" "lb_info" {
  load_balancer_id = var.lb_ocid
}

resource "oci_core_network_security_group" "lb_nsg" {
  compartment_id = var.oci_compartment_id
  vcn_id         = var.oke_vcn_id

  display_name = "public_to_${var.name}"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
}

resource "oci_core_network_security_group_security_rule" "public_to_lb" {
  for_each = toset(var.access_ip_list)

  network_security_group_id = oci_core_network_security_group.lb_nsg.id

  description = "Allow access to ${var.name}"
  source      = each.key
  source_type = "CIDR_BLOCK"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = var.port
      min = var.port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "lb_to_public" {
  for_each = toset(var.access_ip_list)

  network_security_group_id = oci_core_network_security_group.lb_nsg.id

  description      = "Allow access from ${var.name}"
  destination      = each.key
  destination_type = "CIDR_BLOCK"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = var.port
      min = var.port
    }
  }
}

## loadbalancer to workers

resource "oci_core_network_security_group_security_rule" "workers_to_lb" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id

  description = "Allow access from workers"
  source      = var.oke_worker_nsg_id
  source_type = "NETWORK_SECURITY_GROUP"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
      min = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "lb_to_workers" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id

  description      = "Allow access to workers"
  destination      = var.oke_worker_nsg_id
  destination_type = "NETWORK_SECURITY_GROUP"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
      min = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "lb_to_workers_nsg" {
  network_security_group_id = var.oke_worker_nsg_id

  description = "Allow access from loadbalancer to ${var.name}"
  source      = oci_core_network_security_group.lb_nsg.id
  source_type = "NETWORK_SECURITY_GROUP"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
      min = data.oci_load_balancer_backend_sets.lb_info.backendsets[0].backend[0].port
    }
  }
}
