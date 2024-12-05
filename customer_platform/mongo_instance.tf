#############
# Instances #
#############

resource "oci_core_subnet" "internal_data" {
  count = var.create_mongo_instance ? 1 : 0

  compartment_id = var.oci_compartment_id
  vcn_id         = module.oci_oke.vcn_id
  cidr_block     = var.internal_data_cidr_block

  display_name = "internal-data"
  freeform_tags = {
    "terraform" : "true",
    "env" : var.environment
  }
  prohibit_public_ip_on_vnic = true
  route_table_id             = module.oci_oke.nat_route_table_id
  # security_list_ids = []
}

resource "oci_core_network_security_group" "mongodb" {
  count = var.create_mongo_instance ? 1 : 0

  compartment_id = var.oci_compartment_id
  vcn_id         = module.oci_oke.vcn_id

  display_name = "mongodb internal access"
}

resource "oci_core_network_security_group_security_rule" "worker_to_mongodb" {
  count = var.create_mongo_instance ? 1 : 0

  network_security_group_id = oci_core_network_security_group.mongodb[0].id

  description = "Allow access from workers to mongodb"
  source      = module.oci_oke.worker_subnet_cidr
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

resource "oci_core_network_security_group_security_rule" "mongodb_to_worker" {
  count = var.create_mongo_instance ? 1 : 0

  network_security_group_id = oci_core_network_security_group.mongodb[0].id

  description      = "Allow access to workers to mongodb"
  destination      = module.oci_oke.worker_subnet_cidr
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

resource "oci_core_network_security_group_security_rule" "bastion_to_mongodb" {
  count = var.create_mongo_instance ? 1 : 0

  network_security_group_id = oci_core_network_security_group.mongodb[0].id

  description = "Allow access from bastion to mongodb"
  source      = module.oci_oke.bastion_nsg_id
  source_type = "NETWORK_SECURITY_GROUP"
  direction   = "INGRESS"
  protocol    = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless   = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "mongodb_to_bastion" {
  count = var.create_mongo_instance ? 1 : 0

  network_security_group_id = oci_core_network_security_group.mongodb[0].id

  description      = "Allow access from bastion to mongodb"
  destination      = module.oci_oke.bastion_nsg_id
  destination_type = "NETWORK_SECURITY_GROUP"
  direction        = "EGRESS"
  protocol         = "6"  # TCP see https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#protocol
  stateless        = true # See https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule#stateless

  tcp_options {
    source_port_range {
      max = 22
      min = 22
    }
  }
}

# data "oci_core_images" "base_images" {
#   compartment_id = var.oci_compartment_id
#   # display_name = "Canonical-Ubuntu-22.04-2023.01.31-0"
#   operating_system = "Ubuntu"
#   operating_system_version = "22.04"
# }

# https://registry.terraform.io/modules/oracle-terraform-modules/compute-instance/oci/latest?tab=inputs
module "oci_instance" {
  count = var.create_mongo_instance ? 1 : 0

  source           = "oracle-terraform-modules/compute-instance/oci"
  version          = "2.4.1"
  compartment_ocid = var.oci_compartment_id
  # source_ocid = data.oci_core_images.base_images.images[0].id'
  source_ocid = var.mongo_image_ocid
  subnet_ocids = [
    oci_core_subnet.internal_data[0].id
  ]

  assign_public_ip = false
  # Default setup
  cloud_agent_plugins = {
    "autonomous_linux" : "ENABLED",
    "bastion" : "ENABLED",
    "block_volume_mgmt" : "DISABLED",
    "custom_logs" : "ENABLED",
    "java_management_service" : "DISABLED",
    "management" : "DISABLED",
    "monitoring" : "ENABLED",
    "osms" : "ENABLED",
    "run_command" : "ENABLED",
    "vulnerability_scanning" : "ENABLED"
  }
  instance_count              = 1
  instance_display_name       = "mongodb"
  instance_flex_memory_in_gbs = var.mongo_memory
  instance_flex_ocpus         = var.mongo_cpu
  instance_state              = "RUNNING"
  primary_vnic_nsg_ids = [
    oci_core_network_security_group.egress_to_public.id,
    oci_core_network_security_group.mongodb[0].id
  ]
  private_ips     = [var.mongo_private_ip]
  shape           = "VM.Standard.E4.Flex"
  ssh_public_keys = var.k8s_public_key
  # Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration
  user_data                  = base64encode(var.mongo_user_data)
  block_storage_sizes_in_gbs = [50] # size_in_gbs
  boot_volume_backup_policy  = var.mongo_volume_backup_policy
}

# Add backup policy to gold to the other block storage
data "oci_core_volume_backup_policies" "default_backup_policies" {}

locals {
  backup_policies = {
    // Iterate through data.oci_core_volume_backup_policies.default_backup_policies and create a map containing name & ocid
    // This is used to specify a backup policy id by name
    for i in data.oci_core_volume_backup_policies.default_backup_policies.volume_backup_policies : i.display_name => i.id
  }
}

resource "oci_core_volume_backup_policy_assignment" "mongo_volume_backup_policy" {
  for_each  = var.create_mongo_instance ? module.oci_instance[0].volume_all_attributes : {}
  asset_id  = each.value.id
  policy_id = local.backup_policies[var.mongo_volume_backup_policy]
}

#############
