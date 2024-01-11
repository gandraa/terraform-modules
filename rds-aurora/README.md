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
| [aws_cloudwatch_log_group.rds_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_alias.rds_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.rds_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.aurora_rds_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.cluster_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.aurora_rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_ssm_parameter.db_master_pass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.generic_pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes. | `string` | `null` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_aurora_ca_certificate"></a> [aurora\_ca\_certificate](#input\_aurora\_ca\_certificate) | Certificate Authority for Aurora | `string` | `"rds-ca-rsa2048-g1"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply. We recommend specifying 3 AZs or using the lifecycle configuration block ignore\_changes argument if necessary. A maximum of 3 AZs can be configured. | `list(string)` | <pre>[<br>  "eu-central-1a",<br>  "eu-central-1b",<br>  "eu-central-1c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. | `number` | `null` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | The number of days to retain CloudWatch logs for the DB instance. | `number` | `7` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The name of the aurora rds cluster. | `string` | n/a | yes |
| <a name="input_cluster_instance_class"></a> [cluster\_instance\_class](#input\_cluster\_instance\_class) | The instance type of the Aurora RDS instances. Can be checked here https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html . | `string` | `"db.t3.medium"` | no |
| <a name="input_cluster_instances_count"></a> [cluster\_instances\_count](#input\_cluster\_instances\_count) | Number of cluster instances. | `number` | `1` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`. | `bool` | `false` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The DB name to create. If omitted, no database is created initially. | `string` | `null` | no |
| <a name="input_db_cluster_instance_class"></a> [db\_cluster\_instance\_class](#input\_db\_cluster\_instance\_class) | The instance type of the Aurora RDS instances. Can be checked here https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html . | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true. | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL). | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use (e.g. postgres). | `string` | `null` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use. | `string` | `null` | no |
| <a name="input_family"></a> [family](#input\_family) | The family of the DB parameter group (e.g. aurora-postgresql14). | `string` | `null` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | value fo the final identifier | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used. | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user. | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A list of DB parameter maps to apply. | `list(map(string))` | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Port the database should listen on. | `number` | `5432` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window. | `string` | `null` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'. | `string` | `null` | no |
| <a name="input_product"></a> [product](#input\_product) | Environment name(e.g. common). | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | determine whether skip\_final\_snapshot should be added or not | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted. | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs. | `list(string)` | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Updated Terraform resource management timeouts. Applies to `aws_rds_cluster` in particular to permit resource management times. | `map(string)` | `{}` | no |
| <a name="input_use_cluster_identifier_prefix"></a> [use\_cluster\_identifier\_prefix](#input\_use\_cluster\_identifier\_prefix) | Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix. | `bool` | `false` | no |
| <a name="input_use_legacy_ssm_path"></a> [use\_legacy\_ssm\_path](#input\_use\_legacy\_ssm\_path) | Whether to use legacy path for SSM. 'False' avoids naming conflicts when deploying multiple aurora instances for same product | `bool` | `true` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_cluster_arn"></a> [db\_cluster\_arn](#output\_db\_cluster\_arn) | The ARN of the RDS cluster. |
| <a name="output_db_cluster_endpoint"></a> [db\_cluster\_endpoint](#output\_db\_cluster\_endpoint) | The connection endpoint |
| <a name="output_db_cluster_engine"></a> [db\_cluster\_engine](#output\_db\_cluster\_engine) | The database engine |
| <a name="output_db_cluster_engine_version"></a> [db\_cluster\_engine\_version](#output\_db\_cluster\_engine\_version) | The database engine |
| <a name="output_db_cluster_id"></a> [db\_cluster\_id](#output\_db\_cluster\_id) | The RDS instance ID |
| <a name="output_db_cluster_port"></a> [db\_cluster\_port](#output\_db\_cluster\_port) | The database port |
| <a name="output_db_cluster_reader_endpoint"></a> [db\_cluster\_reader\_endpoint](#output\_db\_cluster\_reader\_endpoint) | The connection endpoint for read-only access. |
| <a name="output_db_cluster_resource_id"></a> [db\_cluster\_resource\_id](#output\_db\_cluster\_resource\_id) | The RDS Resource ID of this instance |
| <a name="output_db_master_password"></a> [db\_master\_password](#output\_db\_master\_password) | The master password |
| <a name="output_db_master_username"></a> [db\_master\_username](#output\_db\_master\_username) | The master username for the database |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | The database name |
<!-- END_TF_DOCS -->