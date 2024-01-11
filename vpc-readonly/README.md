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
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.private_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.public_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_security_groups.eks_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_security_groups.rds_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpcs.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_security_group_search_tags"></a> [eks\_security\_group\_search\_tags](#input\_eks\_security\_group\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "aws:eks:cluster-name": "*"<br>}</pre> | no |
| <a name="input_private_secondary_subnets_search_tags"></a> [private\_secondary\_subnets\_search\_tags](#input\_private\_secondary\_subnets\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "Name": "*private*",<br>  "Type": "secondary"<br>}</pre> | no |
| <a name="input_private_subnets_search_tags"></a> [private\_subnets\_search\_tags](#input\_private\_subnets\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "Name": "*Private*"<br>}</pre> | no |
| <a name="input_public_secondary_subnets_search_tags"></a> [public\_secondary\_subnets\_search\_tags](#input\_public\_secondary\_subnets\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "Name": "*private*",<br>  "Type": "secondary"<br>}</pre> | no |
| <a name="input_public_subnets_search_tags"></a> [public\_subnets\_search\_tags](#input\_public\_subnets\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "Name": "*Public*"<br>}</pre> | no |
| <a name="input_vpc_search_tags"></a> [vpc\_search\_tags](#input\_vpc\_search\_tags) | n/a | `map(any)` | <pre>{<br>  "application": "cbplus"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_nodegroup_securitygroup_ids"></a> [eks\_nodegroup\_securitygroup\_ids](#output\_eks\_nodegroup\_securitygroup\_ids) | n/a |
| <a name="output_eks_securitygroup_ids"></a> [eks\_securitygroup\_ids](#output\_eks\_securitygroup\_ids) | n/a |
| <a name="output_privatae_secondary_subnets_perAz"></a> [privatae\_secondary\_subnets\_perAz](#output\_privatae\_secondary\_subnets\_perAz) | n/a |
| <a name="output_private_secondary_subnet_ids"></a> [private\_secondary\_subnet\_ids](#output\_private\_secondary\_subnet\_ids) | Secondary subnets - Private |
| <a name="output_private_secondary_subnets_perAzId"></a> [private\_secondary\_subnets\_perAzId](#output\_private\_secondary\_subnets\_perAzId) | n/a |
| <a name="output_private_secondary_subnets_routtable_perAzId"></a> [private\_secondary\_subnets\_routtable\_perAzId](#output\_private\_secondary\_subnets\_routtable\_perAzId) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_private_subnets_perAz"></a> [private\_subnets\_perAz](#output\_private\_subnets\_perAz) | n/a |
| <a name="output_private_subnets_perAzId"></a> [private\_subnets\_perAzId](#output\_private\_subnets\_perAzId) | n/a |
| <a name="output_private_subnets_routtable_perAzId"></a> [private\_subnets\_routtable\_perAzId](#output\_private\_subnets\_routtable\_perAzId) | n/a |
| <a name="output_public_secondary_subnet_ids"></a> [public\_secondary\_subnet\_ids](#output\_public\_secondary\_subnet\_ids) | Secondary subnets - Public |
| <a name="output_public_secondary_subnets_perAz"></a> [public\_secondary\_subnets\_perAz](#output\_public\_secondary\_subnets\_perAz) | n/a |
| <a name="output_public_secondary_subnets_perAzId"></a> [public\_secondary\_subnets\_perAzId](#output\_public\_secondary\_subnets\_perAzId) | n/a |
| <a name="output_public_secondary_subnets_routtable_perAzId"></a> [public\_secondary\_subnets\_routtable\_perAzId](#output\_public\_secondary\_subnets\_routtable\_perAzId) | n/a |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | Outputs for public subnets |
| <a name="output_public_subnets_perAz"></a> [public\_subnets\_perAz](#output\_public\_subnets\_perAz) | n/a |
| <a name="output_public_subnets_perAzId"></a> [public\_subnets\_perAzId](#output\_public\_subnets\_perAzId) | n/a |
| <a name="output_public_subnets_routtable_perAzId"></a> [public\_subnets\_routtable\_perAzId](#output\_public\_subnets\_routtable\_perAzId) | n/a |
| <a name="output_rds_securitygroup_ids"></a> [rds\_securitygroup\_ids](#output\_rds\_securitygroup\_ids) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->