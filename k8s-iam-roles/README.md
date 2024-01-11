<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.iam_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_managed_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | AWS account Id. | `string` | n/a | yes |
| create\_vpc\_cni\_role | Determines whether to create VPC CNI IAM role to vpc-cni. | `bool` | n/a | yes |
| eks\_account | Name of account to create EKS cluster. | `string` | n/a | yes |
| eks\_environment | Environment name(e.g. cbplus). | `string` | n/a | yes |
| iam\_roles | List of IAM Roles. | <pre>list(<br>    object({<br>      role_name = string<br>      namespace = string<br>      policies = list(object({<br>        file_name = string<br>        resources = string<br>      }))<br>  }))</pre> | n/a | yes |
| oidc | OIDC of EKS cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_roles | ARNs of K8S IAM Roles. |
<!-- END_TF_DOCS -->