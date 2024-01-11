<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.eks_node_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.eks_node_group_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_node_group_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_custom_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_managed_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.eks_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.ec2_node_templates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ec2_instance_type_offering.az_instance_type](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offering) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_ssm_parameter.latest_eks_ami_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cni_version"></a> [cni\_version](#input\_cni\_version) | n/a | `string` | `""` | no |
| <a name="input_eks_account"></a> [eks\_account](#input\_eks\_account) | Name of account to create EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_ami_version"></a> [eks\_ami\_version](#input\_eks\_ami\_version) | AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version. | `string` | `null` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_environment"></a> [eks\_environment](#input\_eks\_environment) | Environment name(e.g. cbplus). | `string` | n/a | yes |
| <a name="input_eks_iam_custom_policies"></a> [eks\_iam\_custom\_policies](#input\_eks\_iam\_custom\_policies) | Custom policies to be attached to EKS Node Group Role. | `list(map(string))` | n/a | yes |
| <a name="input_eks_iam_managed_policies"></a> [eks\_iam\_managed\_policies](#input\_eks\_iam\_managed\_policies) | Managed policies to be attached to EKS Node Group Role. | `list(string)` | `[]` | no |
| <a name="input_eks_node_group_azs"></a> [eks\_node\_group\_azs](#input\_eks\_node\_group\_azs) | AZ to the Node Group. | `list(map(string))` | n/a | yes |
| <a name="input_eks_region"></a> [eks\_region](#input\_eks\_region) | Region to create EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Kubernetes version of the EKS cluster | `string` | `"1.21"` | no |
| <a name="input_imds_v1_disabled"></a> [imds\_v1\_disabled](#input\_imds\_v1\_disabled) | Access instance metadata from a running instance using IMDS. | `bool` | `false` | no |
| <a name="input_kubernetes_labels"></a> [kubernetes\_labels](#input\_kubernetes\_labels) | Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. | `map(string)` | `{}` | no |
| <a name="input_kubernetes_taints"></a> [kubernetes\_taints](#input\_kubernetes\_taints) | List of `key`, `value`, `effect` objects representing Kubernetes taints. | <pre>list(object({<br>    key    = string<br>    value  = string<br>    effect = string<br>  }))</pre> | `[]` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | prefix of the node group name | `string` | `""` | no |
| <a name="input_node_asg_desired_size"></a> [node\_asg\_desired\_size](#input\_node\_asg\_desired\_size) | Desired capacity of Node Group ASG. | `number` | `2` | no |
| <a name="input_node_asg_max_size"></a> [node\_asg\_max\_size](#input\_node\_asg\_max\_size) | Maximum size of Node Group ASG. Set to at least 1 greater than NodeAutoScalingGroupDesiredCapacity. | `number` | `3` | no |
| <a name="input_node_asg_min_size"></a> [node\_asg\_min\_size](#input\_node\_asg\_min\_size) | Minimum size of Node Group ASG. | `number` | `1` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | EC2 instance type for the node instances. | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_node_volume_size"></a> [node\_volume\_size](#input\_node\_volume\_size) | Node volume size. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_node_group_names"></a> [eks\_node\_group\_names](#output\_eks\_node\_group\_names) | EKS Node Group names. |
| <a name="output_node_group_role"></a> [node\_group\_role](#output\_node\_group\_role) | Name of the worker nodes IAM role. |
<!-- END_TF_DOCS -->