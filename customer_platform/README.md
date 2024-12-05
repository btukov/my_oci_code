# customer_platform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.5 |
| oci | ~> 5.2.1 |

## Providers

| Name | Version |
|------|---------|
| oci | 5.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| lb\_nsgs | ./lb_nsgs | n/a |
| oci\_instance | oracle-terraform-modules/compute-instance/oci | 2.4.1 |
| oci\_oke | oracle-terraform-modules/oke/oci | 5.0.0-beta.4 |

## Resources

| Name | Type |
|------|------|
| [oci_core_network_security_group.egress_to_public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.mongodb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.public_to_mgmt](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group.ssh_to_internal_data](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.allow_http_tcp_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_https_tcp_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_ssh_into_internal_data_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_udp_dns_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.allow_udp_ntp_egress](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.bastion_to_mongodb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.cp_to_mgmt](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.k8s_to_public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.k8sapi_to_cp](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.mgmt_to_cp](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.mongo_to_public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.mongodb_to_bastion](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.mongodb_to_worker](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.public_to_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.public_to_mongo](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.worker_to_mongodb](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_public_ip.kafka](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_public_ip.mgmt](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_public_ip.smartsafe](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_public_ip.web](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_subnet.internal_data](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_volume_backup_policy_assignment.mongo_volume_backup_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_load_balancer_backend.mgmt_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend) | resource |
| [oci_load_balancer_backend_set.mgmt_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_backend_set) | resource |
| [oci_load_balancer_listener.mgmt_k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_listener) | resource |
| [oci_load_balancer_load_balancer.mgmt](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/load_balancer_load_balancer) | resource |
| [oci_waf_web_app_firewall_policy.waf_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/waf_web_app_firewall_policy) | resource |
| [oci_core_volume_backup_policies.default_backup_policies](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_volume_backup_policies) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_allowed\_cidrs | Allow list for public IP of the Bastion instance | `list(string)` | n/a | yes |
| bastion\_public\_ip | Hardcode the public IP. !!! Never tested | `string` | `null` | no |
| cluster\_name | Optional. Set a cluster name. By default: customer-platform-<ENVIRONMENT NAME> | `string` | `null` | no |
| create\_mongo\_instance | Define if a mongodb instance should be create or not | `bool` | `false` | no |
| environment | Name of the environment. Preferably all lowwercase | `string` | `"dev"` | no |
| home\_region | The tenancy's home region. Required to perform identity operations | `string` | n/a | yes |
| install\_metric\_server | Whether to deploy the Kubernetes Metrics Server Helm chart. See https://github.com/kubernetes-sigs/metrics-server | `bool` | `false` | no |
| internal\_data\_cidr\_block | cidr block for the internal-data subne | `string` | `null` | no |
| k8s\_private\_key | Global ssh private key | `string` | n/a | yes |
| k8s\_public\_key | Global ssh public key | `string` | n/a | yes |
| k8s\_version | Kubernetes cluster version. Note that the node doesn't update by themselves and you should create another pool to 'upgrade' it | `string` | `"v1.26.2"` | no |
| kafka\_private\_ip | n/a | `string` | `null` | no |
| loadbalancer\_nsgs | n/a | <pre>list(object({<br>    name              = string<br>    access_ip_list    = list(string)<br>    loadbalancer_ocid = string<br>    port              = number<br>  }))</pre> | `[]` | no |
| mgmt\_access\_ip\_list | Allow list to access managmeent IP | `list(string)` | n/a | yes |
| mgmt\_private\_ip | n/a | `string` | `null` | no |
| mongo\_cpu | mongodb vcpu number | `number` | `8` | no |
| mongo\_image\_ocid | mongodb instance source image ocid | `string` | `""` | no |
| mongo\_memory | mongodb memory size in GB | `number` | `16` | no |
| mongo\_private\_ip | Hardcode the private IP | `string` | `null` | no |
| mongo\_user\_data | templatefile of user-data file | `string` | `null` | no |
| mongo\_volume\_backup\_policy | Choose between default backup policies : gold, silver, bronze. Use disabled to affect no backup policy on the Boot Volume | `string` | `"disabled"` | no |
| oci\_compartment\_id | ID of the compartment to create where we will deploy everything | `string` | n/a | yes |
| oci\_tenancy\_ocid | Tenancy oracle cloud identifier | `string` | n/a | yes |
| operator\_private\_ip | Hardcode the private IP | `string` | `null` | no |
| region | Region where the cluster should be deployed | `string` | n/a | yes |
| smartsafe\_private\_ip | n/a | `string` | `null` | no |
| web\_private\_ip | n/a | `string` | `null` | no |
| worker\_pools | Worker pool definition. Here you can define the workers shape and node labels for example | `map(any)` | `{}` | no |
| worker\_shape | Default worker shape on pool creation | `map(any)` | <pre>{<br>  "boot_volume_size": 50,<br>  "memory": 8,<br>  "ocpus": 4,<br>  "shape": "VM.Standard.E4.Flex"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
