<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | = 2.5.1 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.aws-vpc-cni](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [null_resource.annotate_nodes](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | n/a | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region where resources are created. | `string` | `"eu-central-1"` | no |
| <a name="input_eks_node_security_group_ids"></a> [eks\_node\_security\_group\_ids](#input\_eks\_node\_security\_group\_ids) | List of Security group ID of EKS nodes. | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_subnets_per_az"></a> [subnets\_per\_az](#input\_subnets\_per\_az) | List of subnet ID per availability zone. | `map` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->