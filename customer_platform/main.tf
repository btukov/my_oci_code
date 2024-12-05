

#############################
# Create container registry #
#############################

# See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/artifacts_container_repository
#
# TODO: There are already a container repository on the root system. It will be a good idea to check wheter it is better to centralize the
# container repository somewhere else where it could be recheable by all the environment/cloud

#############################


##############
# create waf #
##############
resource "oci_waf_web_app_firewall_policy" "waf_policy" {
  compartment_id = var.oci_compartment_id
  display_name   = "Sesami WAF"

  actions {
    name = "Allow Action"
    type = "ALLOW"
  }

  actions {
    code = 403
    name = "403 Response Code Action"
    type = "RETURN_HTTP_RESPONSE"
  }

  request_access_control {
    default_action_name = "Allow Action"

    rules {
      action_name = "403 Response Code Action"
      name        = "BLOCK_COUNTRIES"
      type        = "ACCESS_CONTROL"
      condition   = "i_contains(['CN', 'RU', 'KP'], connection.source.geo.countryCode)"
    }
  }
}

##############


#######################
# Reserved public IPs #
#######################

resource "oci_core_public_ip" "kafka" {
  compartment_id = var.oci_compartment_id
  lifetime       = "RESERVED"

  display_name = "${var.environment}-kafka"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  private_ip_id = var.kafka_private_ip
}

resource "oci_core_public_ip" "web" {
  compartment_id = var.oci_compartment_id
  lifetime       = "RESERVED"

  display_name = "${var.environment}-web"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  private_ip_id = var.web_private_ip
}

resource "oci_core_public_ip" "smartsafe" {
  compartment_id = var.oci_compartment_id
  lifetime       = "RESERVED"

  display_name = "${var.environment}-smartsafe"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  private_ip_id = var.smartsafe_private_ip
}

resource "oci_core_public_ip" "mgmt" {
  compartment_id = var.oci_compartment_id
  lifetime       = "RESERVED"

  display_name = "${var.environment}-mgmt"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  private_ip_id = var.mgmt_private_ip
}

#######################


#######################
# Loadbalancer's nsgs #
#######################

module "lb_nsgs" {
  for_each = { for lb in var.loadbalancer_nsgs : lb.name => lb }

  source = "./lb_nsgs"

  lb_ocid            = each.value.loadbalancer_ocid
  oci_compartment_id = var.oci_compartment_id
  oke_vcn_id         = module.oci_oke.vcn_id
  oke_worker_nsg_id  = module.oci_oke.worker_nsg_id
  name               = each.key
  environment        = var.environment
  access_ip_list     = each.value.access_ip_list
  port               = each.value.port
}

#######################
