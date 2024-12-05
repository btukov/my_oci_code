resource "oci_identity_compartment" "ses_dev" {
  provider       = oci.home
  compartment_id = var.oci_compartment_parent_id
  description    = "Customer platform - ${title(local.dev_environment)} environment"
  name           = "customer-platform-${local.dev_environment}"
}

moved {
  from = module.customer_platform_dev.oci_identity_compartment.customer_platform_compartment
  to   = oci_identity_compartment.ses_dev
}

module "customer_platform_dev" {
  source = "./customer_platform"

  providers = {
    oci      = oci.frankfurt
    oci.home = oci.home
  }

  oci_compartment_id = oci_identity_compartment.ses_dev.id
  oci_tenancy_ocid   = var.oci_tenancy_ocid
  home_region        = var.oci_region
  region             = var.oci_region

  environment = local.dev_environment

  k8s_version           = "v1.28.2"
  cluster_type          = "enhanced"
  k8s_private_key       = var.oke_dev_ssh_private_key
  k8s_public_key        = var.oke_dev_ssh_public_key
  bastion_allowed_cidrs = var.bastion_allowlist_ips
  bastion_public_ip     = "130.61.116.189"
  operator_private_ip   = "10.0.0.101"
  install_metric_server = true
  worker_shape          = { "boot_volume_size" : 100, "memory" : 8, "ocpus" : 4, "shape" : "VM.Standard.E4.Flex" }
  worker_pools = {
    dev = {
      shape            = "VM.Standard.E4.Flex"
      ocpus            = 4
      memory           = 32
      size             = 3
      boot_volume_size = 100
      autoscale        = false
      node_labels = {
        env = local.dev_environment
      }
    }

    qa = {
      shape            = "VM.Standard.E4.Flex"
      ocpus            = 4
      memory           = 16
      size             = 3
      boot_volume_size = 100
      autoscale        = false
      node_labels = {
        env = local.qa_environment
      }
    }
  }

  create_mongo_instance = false

  mgmt_access_ip_list = var.dev_mgmt_access_ip_list

  loadbalancer_nsgs = [
    {
      name              = "kafka-dev"
      access_ip_list    = var.dev_kafka_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaaktsb3snirvosssuk4eqfyrolwbbpbsmcggfoeyqel6nou44jyf3q"
      port              = 9094
    },
    {
      name              = "web-dev"
      access_ip_list    = var.dev_web_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaav5vz4g7qmysqzbhyl3qtaru7bw2m5hglissdnxtcl2vydabz4v6q"
      port              = 443
    },
    {
      name              = "smartsafe-dev"
      access_ip_list    = var.dev_smartsafe_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaag4pidwzzld32r3egnpbozf6cxy7tq6qv3erok4aztmyergjbrvcq"
      port              = 4243
    },
    {
      name              = "kafka-qa"
      access_ip_list    = var.dev_web_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaa3bblil6jeiivxi5wlpwuyjb2dykunsrzpu3ombvcpb6f3wv3q3sq"
      port              = 9094
    },
    {
      name              = "web-qa"
      access_ip_list    = var.qa_web_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaaochwepnodnq3vv4im5kqtniet6fsbscz4ftsuaneyudkrvl3pdyq"
      port              = 443
    },
    {
      name              = "smartsafe-qa"
      access_ip_list    = var.qa_smartsafe_access_ip_list
      loadbalancer_ocid = "ocid1.loadbalancer.oc1.eu-frankfurt-1.aaaaaaaawxukybois7ri3xky7x6pdxsw7anjq3i35yjnr7e3oax5m26ehrjq"
      port              = 4243
    }
  ]

  kafka_private_ip     = "ocid1.privateip.oc1.eu-frankfurt-1.abtheljsyuhlyuojmrniff2s3fkonjbtvyv5exv64a2htjffnytvh24f5zza"
  web_private_ip       = "ocid1.privateip.oc1.eu-frankfurt-1.abtheljta5acpgxvzjetm7xfqlaveojiijpsxjrx22ucvfz3u7hgyo2tet3q"
  smartsafe_private_ip = "ocid1.privateip.oc1.eu-frankfurt-1.abtheljtjavwcl2qde2xdhrus4o2aztdobsx6xuipn45uehw7u2lz7tenpua"
  mgmt_private_ip      = "ocid1.privateip.oc1.eu-frankfurt-1.abtheljtitufrum2gns4jkuqxoyj37ybzt7sieiemyiztzqaylp6u6ohg7wq"
}
