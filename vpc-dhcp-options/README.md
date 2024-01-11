<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc_dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/3.1.0/docs/data-sources/vpc_dhcp_options) | data source |
| [aws_vpc_dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc\_id | The ID of the VPC that you want to associate the dhcp_options with. | `string` | n/a | yes |
| dhcp\_option\_filter | List of custom filters: name -> The name of the field to filter, values ->  Set of values for filtering. | `list` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="dhcp_option_set_id"></a> [dhcp\_option\_set\_id](#dhcp\_option\_set\_id) | n/a |
| <a name="aws_vpc_dhcp_options_association_id"></a> [aws\_vpc\_dhcp\_options\_association\_id](#aws\_vpc\_dhcp\_options\_association\_id) | n/a |
<!-- END_TF_DOCS -->