<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_docdb_cluster.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_docdb_cluster_parameter_group.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group) | resource |
| [aws_docdb_subnet_group.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group) | resource |
| [aws_kms_alias.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_from_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.docdb_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.docdb_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.docdb](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_security\_groups | List of existing Security Groups to be allowed to connect to the DocumentDB cluster | `list(string)` | `[]` | no |
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| auto\_minor\_version\_upgrade | Specifies whether any minor engine upgrades will be applied automatically to the DB instance during the maintenance window or not | `bool` | `false` | no |
| availability\_zones | A list of EC2 Availability Zones that instances in the DB cluster can be created in. | `list(string)` | n/a | yes |
| cluster\_parameter\_family | The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html | `string` | `"docdb5.0"` | no |
| cluster\_parameters | List of DB parameters to apply | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| cluster\_size | Number of DB instances to create in the cluster | `number` | n/a | yes |
| db\_port | DocumentDB port | `number` | `27017` | no |
| deletion\_protection | A value that indicates whether the DB cluster has deletion protection enabled | `bool` | `true` | no |
| enable\_performance\_insights | Specifies whether to enable Performance Insights for the DB Instance. | `bool` | `false` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch. The following log types are supported: `audit`, `error`, `general`, `slowquery` | `list(string)` | `[]` | no |
| engine | The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb` | `string` | `"docdb"` | no |
| engine\_version | The version number of the database engine to use | `string` | `"5.0.0"` | no |
| identifier | The name of the DocDB cluster. | `string` | `""` | no |
| instance\_class | The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs | `string` | n/a | yes |
| kms\_key\_id | The ARN for the KMS encryption key. When specifying `kms_key_id`, `storage_encrypted` needs to be set to `true` | `string` | `""` | no |
| master\_username | An alphanumeric string that defines the login ID for the user. | `string` | n/a | yes |
| preferred\_backup\_window | Daily time range during which the backups happen | `string` | `"00:00-02:00"` | no |
| preferred\_maintenance\_window | The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`. | `string` | `"Mon:22:00-Mon:23:00"` | no |
| product | The name of the XB+ product, eg. 'xcds' to construct path to AWS SSM Parameter Store | `string` | `""` | no |
| retention\_period | Number of days to retain backups for | `number` | `5` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted | `bool` | `false` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot | `string` | `""` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| subnet\_ids | A list of VPC subnet IDs. | `list(string)` | `[]` | no |
| vpc\_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the cluster |
| cluster\_members | Cluster Members |
| cluster\_name | Cluster Identifier |
| cluster\_resource\_id | Cluster Resource ID |
| endpoint | Endpoint of the DocumentDB cluster |
| master\_password | The master password |
| master\_username | The master username for the database |
| reader\_endpoint | A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas |
| security\_group\_arn | ARN of the DocumentDB cluster Security Group |
| security\_group\_id | ID of the DocumentDB cluster Security Group |
| security\_group\_name | Name of the DocumentDB cluster Security Group |
<!-- END_TF_DOCS -->