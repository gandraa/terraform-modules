<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_route_table_association.route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.main-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_ipv4_cidr_block_association.secondary_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [null_resource.cidr_subnets](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_name | Name of the account in which the subnets are created | `string` | n/a | yes |
| aws\_region | Region where resources are created. | `string` | `"eu-central-1"` | no |
| cidr\_block | CIDR block of the VPC. | `string` | `"100.64.0.0/16"` | no |
| environment | Name of the environment in which the subnets are created | `string` | n/a | yes |
| route\_tables | Map of route tables for each availability zone which are attach to the created subnets. e..g euc1-az1 --> routeTableID | `map(any)` | `{}` | no |
| tags | Tags to apply to the resources. | `map(any)` | `{}` | no |
| vpc\_id | VPC ID to add the secondary range. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnet\_ids | n/a |
| private\_subnets\_arns | n/a |
| private\_subnets\_perAz | n/a |
| private\_subnets\_perAzName | n/a |
<!-- END_TF_DOCS -->