# workspace-oracle-sesami-global

This is the global infrastructure definition of Sesami

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.5 |
| oci | ~> 5.2.1 |

## Providers

| Name | Version |
|------|---------|
| oci.home | 5.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| customer\_platform\_demo | ./customer_platform | n/a |
| customer\_platform\_dev | ./customer_platform | n/a |
| customer\_platform\_drp | ./customer_platform | n/a |
| customer\_platform\_preprod | ./customer_platform | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_identity_compartment.ses_demo](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.ses_dev](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.ses_drp](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.ses_preprod](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_allowlist\_ips | Allow list for public IP of the Bastion instance | `list(string)` | n/a | yes |
| demo\_kafka\_access\_ip\_list | Allow list for kafka in demo | `list(string)` | n/a | yes |
| demo\_mgmt\_access\_ip\_list | Allow list for load balancer management access on Demo environment | `list(string)` | n/a | yes |
| demo\_smartsafe\_access\_ip\_list | Allow list for smartsafe in demo | `list(string)` | n/a | yes |
| demo\_web\_access\_ip\_list | Allow list for web in demo | `list(string)` | n/a | yes |
| dev\_kafka\_access\_ip\_list | Allow list for kafka in dev | `list(string)` | n/a | yes |
| dev\_mgmt\_access\_ip\_list | Allow list for load balancer management access on Dev environment | `list(string)` | n/a | yes |
| dev\_smartsafe\_access\_ip\_list | Allow list for smartsafe in dev | `list(string)` | n/a | yes |
| dev\_web\_access\_ip\_list | Allow list for web in dev | `list(string)` | n/a | yes |
| home\_mongo\_image\_ocid | n/a | `string` | `""` | no |
| oci\_compartment\_parent\_id | Compartment parent id. Usually the root on oracle cloud | `string` | n/a | yes |
| oci\_drp\_region | Default region | `string` | n/a | yes |
| oci\_fingerprint | user ssh fingerprint | `string` | n/a | yes |
| oci\_private\_key | User ssh private key | `string` | n/a | yes |
| oci\_region | Default region | `string` | n/a | yes |
| oci\_tenancy\_ocid | Tenancy oracle cloud identifier | `string` | n/a | yes |
| oci\_user\_ocid | User oracle cloud identifier | `string` | n/a | yes |
| oke\_demo\_ssh\_private\_key | Global ssh private key for Demo environment | `string` | n/a | yes |
| oke\_demo\_ssh\_public\_key | Global ssh public key for Demo environment | `string` | n/a | yes |
| oke\_dev\_ssh\_private\_key | Global ssh private key for Dev environment | `string` | n/a | yes |
| oke\_dev\_ssh\_public\_key | Global ssh public key for Dev environment | `string` | n/a | yes |
| oke\_preprod\_ssh\_private\_key | Global ssh private key for Preprod environment | `string` | n/a | yes |
| oke\_preprod\_ssh\_public\_key | Global ssh public key for Preprod environment | `string` | n/a | yes |
| preprod\_kafka\_access\_ip\_list | Allow list for kafka in preprod | `list(string)` | n/a | yes |
| preprod\_mgmt\_access\_ip\_list | Allow list for load balancer management access on Preprod environment | `list(string)` | n/a | yes |
| preprod\_smartsafe\_access\_ip\_list | Allow list for smartsafe in preprod | `list(string)` | n/a | yes |
| preprod\_web\_access\_ip\_list | Allow list for web in preprod | `list(string)` | n/a | yes |
| prod\_kafka\_access\_ip\_list | Allow list for kafka in prod | `list(string)` | n/a | yes |
| prod\_smartsafe\_access\_ip\_list | Allow list for smartsafe in prod | `list(string)` | n/a | yes |
| prod\_web\_access\_ip\_list | Allow list for web in prod | `list(string)` | n/a | yes |
| qa\_kafka\_access\_ip\_list | Allow list for kafka in dev | `list(string)` | n/a | yes |
| qa\_smartsafe\_access\_ip\_list | Allow list for smartsafe in qa | `list(string)` | n/a | yes |
| qa\_web\_access\_ip\_list | Allow list for web in qa | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to use

This terraform repository is a mean to call the customer_platform module multiple times. In this documentation we will create a kubernetes platform for one environment "tf" as an example.

### customer_platform mandatory definition

```bash
# Here the module name could be whatever you want. For this exampl it is "customer_platform_tf"
module "customer_platform_tf" {
  # As it is a local module you don't need to specify a version as it is versionless
  source = "./customer_platform"

  # Should be used here to inherit providers declared on root
  # see: https://developer.hashicorp.com/terraform/language/modules/develop/providers
  providers = {
    oci      = oci.frankfurt
    oci.home = oci.home
  }
}
```

### A working example

> You should create the department if it doesn't exists firts or you will have an error if you try to create the k8s environment.

```bash
module "customer_platform_tf" {
  source = "./customer_platform"

  providers = {
    oci      = oci.frankfurt
    oci.home = oci.home
  }

  oci_compartment_parent_id = var.oci_compartment_parent_id
  oci_tenancy_ocid          = var.oci_tenancy_ocid

  # The tenancy's home region. Required to perform identity operations
  home_region               = var.oci_region

  # Region where the cluster should be deployed
  region                    = var.oci_region

  environment = "tf"

  k8s_version           = "v1.26.2"
  k8s_private_key       = var.ssh_private_key
  k8s_public_key        = var.ssh_public_key
  bastion_allowed_cidrs = [ "123.456.789.123" ]

  # You can add here the public IP after the Bastion instance is created
  bastion_public_ip     = ""

  # You can add here the private IP after the Operator instance is created
  operator_private_ip   = ""

  # This is the default shape that workers on pool will take if there are not defined in the worker_pools definition
  worker_shape          = { "boot_volume_size" : 50, "memory" : 8, "ocpus" : 4, "shape" : "VM.Standard.E4.Flex" }

  # worker pool is a dictionnary of pools definition
  worker_pools = {

    # This pool specify a size of 3 nodes with adding dictionnary of labels to the default labels existing on the nodes
    # The other options will be set to their defaults. The worker shape will be setted from the worker_shape definition
    # "wp1" is the worker pool name
    wp1 = {
      size             = 3
      node_labels = {
        env = "dev"
      }
    }

    # This is a pool definition with custom shape
    wp2 = {
      shape            = "VM.Standard.E4.Flex"
      ocpus            = 4
      memory           = 16
      size             = 3
      boot_volume_size = 50
      # This is mandatory only when set to true. This is still in beta
      autoscale        = false
      node_labels = {
        env = "qa"
      }
    }
  }

  # This is the cidr block definition of the subnet internal-data. It will be created only if the
  # mongodb instance is needed to be created
  internal_data_cidr_block   = "10.0.10.0/24"
  # Wheter to create a mongodb instance or not. False by default
  create_mongo_instance      = true
  mongo_image_ocid           = "OCID image from the region"
  # Hardcode the private IP after the instance is created
  mongo_private_ip           = "10.0.10.10"
  # This is an example of how to send user-data template
  # see: https://developer.hashicorp.com/terraform/language/functions/templatefile
  mongo_user_data            = templatefile("mongo.yaml", { devops_key = var.ssh_public_key })
  # Volume backup policy could be gold, silver, bronze or disabled
  mongo_volume_backup_policy = "gold"

  mgmt_access_ip_list        = var.dev_mgmt_access_ip_list

  mgmt_access_ip_list = var.dev_mgmt_access_ip_list

  # This list of object here is to create public whitelisted access to the service
  # managed by the loadbalancer created via the k8s nginx annotations
  loadbalancer_nsgs = [
    {
      name = "kafka-dev"
      access_ip_list = var.dev_kafka_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 9094
    },
    {
      name = "web-dev"
      access_ip_list = var.dev_web_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 443
    },
    {
      name = "smartsafe-dev"
      access_ip_list = var.dev_smartsafe_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 4243
    },
    {
      name = "kafka-qa"
      access_ip_list = var.qa_kafka_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 9094
    },
    {
      name = "web-qa"
      access_ip_list = var.qa_web_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 443
    },
    {
      name = "smartsafe-qa"
      access_ip_list = var.qa_smartsafe_access_ip_list
      loadbalancer_ocid = "ocid of the loadbalancer here for obtaining the bavkend port"
      port = 4243
    }
  ]

  # This is a wierd part (or is it ?) that is needed when a reserved public IP is created, you
  # will need to hardcode this part because you will have an error in terraform that will try to change the ID for a null
  #kafka_private_ip = ""
  #web_private_ip       = ""
  #smartsafe_private_ip = ""
  #mgmt_private_ip      = ""
}
```

## Development

### Setup

Requirements:

- \>= python 3.8
- [pre-commit](https://pre-commit.com/)
- terraform (via [tfenv](https://github.com/tfutils/tfenv) or [tfswitch](https://tfswitch.warrensbox.com/) **strongly** recommended)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)
- [tflint](https://github.com/terraform-linters/tflint)
- [checkov](https://www.checkov.io/) (could be installed via pipenv)

```bash
# Install and setup the environment
pip install --user --upgrade \
  pre-commit \
  checkov

# Ensuring that pre-commit watch this repository
pre-commit install
```
