<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_role.eks_control_plane_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_policy_attachments_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy_attachments_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cluster_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.control_plane_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_enable\_key\_rotation | Cluster Encryption Config KMS Key Resource argument - enable kms key rotation | `bool` | `true` | no |
| cluster\_encryption\_config\_enabled | Set to `true` to enable Cluster Encryption Configuration | `bool` | `false` | no |
| cluster\_encryption\_config\_kms\_key\_id | KMS Key ID to use for cluster encryption config. | `string` | `""` | no |
| cluster\_encryption\_config\_resources | Cluster Encryption Config Resources to encrypt, e.g. ['secrets'] | `list(any)` | <pre>[<br>  "secrets"<br>]</pre> | no |
| eks\_account | Name of account to create EKS cluster. | `string` | n/a | yes |
| eks\_cluster\_name | Name of EKS cluster. | `string` | n/a | yes |
| eks\_environment | Environment name(e.g. cbplus). | `string` | n/a | yes |
| eks\_role\_name | Name of IAM Role to EKS control plane. | `string` | n/a | yes |
| eks\_version | Version of EKS cluster. | `string` | n/a | yes |
| enabled\_cluster\_log\_types | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | `[]` | no |
| vpc\_id | VPC to create cluster. | `string` | n/a | yes |
| vpc\_subnet\_ids | Subnets to be attached to EKS. | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_certificate | Cluster CA Certificate. |
| cluster\_endpoint | The endpoint to reach the cluster. |
| cluster\_identity\_oidc\_issuer | The OIDC Identity issuer for the cluster. |
| cluster\_kms\_key\_alias | The KMS key alias to encrypt the cluster configuration. |
| cluster\_kms\_key\_id | The KMS key to encrypt the cluster configuration. |
| cluster\_name | The name of the EKS cluster. |
| cluster\_securit\_group\_id | The security group of the cluster. |
<!-- END_TF_DOCS -->