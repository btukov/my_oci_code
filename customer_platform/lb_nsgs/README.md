# lb_nsgs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| oci | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_network_security_group.lb_nsg](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.lb_to_public](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.lb_to_workers](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.lb_to_workers_nsg](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.public_to_lb](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_network_security_group_security_rule.workers_to_lb](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_load_balancer_backend_sets.lb_info](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/load_balancer_backend_sets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_ip\_list | n/a | `list(string)` | n/a | yes |
| environment | n/a | `string` | n/a | yes |
| lb\_ocid | n/a | `string` | n/a | yes |
| name | n/a | `string` | n/a | yes |
| oci\_compartment\_id | n/a | `string` | n/a | yes |
| oke\_vcn\_id | n/a | `string` | n/a | yes |
| oke\_worker\_nsg\_id | n/a | `string` | n/a | yes |
| port | n/a | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
