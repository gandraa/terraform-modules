<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.rds_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.rds_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_alias.rds_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.rds_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_ssm_parameter.root_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.db_master_pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_db_event_subscription.event_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |


## Inputs

| Name                                        | Description | Type                | Default | Required |
|---------------------------------------------|-------------|---------------------|---------|:--------:|
| allocated\_storage                          | The allocated storage in gigabytes. | `string`            | `null` |    no    |
| allow\_major\_version\_upgrade              | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. | `bool`              | `false` |    no    |
| apply\_immediately                          | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool`              | `false` |    no    |
| auto\_minor\_version\_upgrade               | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. | `bool`              | `true` |    no    |
| backup\_retention\_period                   | The days to retain backups for. | `number`            | `null` |    no    |
| backup\_window                              | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window. | `string`            | `null` |    no    |
| cloudwatch\_log\_group\_kms\_key\_id        | The ARN of the KMS Key to use when encrypting log data | `string`            | `null` |    no    |
| cloudwatch\_log\_group\_retention\_in\_days | The number of days to retain CloudWatch logs for the DB instance. | `number`            | `7` |    no    |
| copy\_tags\_to\_snapshot                    | On delete, copy all Instance tags to the final snapshot. | `bool`              | `false` |    no    |
| create\_cloudwatch\_log\_group              | Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`. | `bool`              | `false` |    no    |
| db\_name                                    | The DB name to create. If omitted, no database is created initially. | `string`            | `null` |    no    |
| deletion\_protection                        | The database can't be deleted when this value is set to true. | `bool`              | `false` |    no    |
| enabled\_cloudwatch\_logs\_exports          | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL). | `list(string)`      | `[]` |    no    |
| engine                                      | The database engine to use. | `string`            | `null` |    no    |
| engine\_version                             | The engine version to use. | `string`            | `null` |    no    |
| environment                                 | Environment name(e.g. common). | `string`            | n/a |   yes    |
| family                                      | The family of the DB parameter group. | `string`            | `null` |    no    |
| identifier                                  | The name of the RDS instance. | `string`            | `""` |    no    |
| instance\_class                             | The instance type of the RDS instance. | `string`            | `null` |    no    |
| kms\_key\_id                                | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used. | `string`            | `null` |    no    |
| maintenance\_window                         | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'. | `string`            | `null` |    no    |
| max\_allocated\_storage                     | Specifies the value for Storage Autoscaling. | `number`            | `0` |    no    |
| multi\_az                                   | Specifies if the RDS instance is multi-AZ. | `bool`              | `false` |    no    |
| parameters                                  | A list of DB parameter maps to apply. | `list(map(string))` | `[]` |    no    |
| port                                        | Port the database should listen on. | `number`            | `5432` |    no    |
| publicly\_accessible                        | Bool to control if instance is publicly accessible. | `bool`              | `false` |    no    |
| security\_group\_ids                        | A list of security group IDs. | `list(string)`      | `[]` |    no    |
| storage\_encrypted                          | Specifies whether the DB instance is encrypted. | `bool`              | `true` |    no    |
| storage\_type                               | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'. | `string`            | `null` |    no    |
| subnet\_ids                                 | A list of VPC subnet IDs. | `list(string)`      | `[]` |    no    |
| timeouts                                    | Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times. | `map(string)`       | `{}` |    no    |
| use\_identifier\_prefix                     | Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix. | `bool`              | `false` |    no    |
| username                                    | Username for the master DB user. | `string`            | `null` |    no    |
| subscription\_name                          | The name of the DB event subscription. By default generated by Terraform. | `string`            | `null` |    no    |
| sns\_topic                                  | The SNS topic to send events to. | `string`            | `null` |   yes    |
| source\_type                                | The type of source that will be generating the events. | `string`            | `null` |    no    |
| source\_ids                                 | A list of identifiers of the event sources for which events will be returned. | `list(string)`            | `null` |    no    |
| event\_categories                           | A list of event categories for a SourceType that you want to subscribe to. | `list(string)`      | `null` |    no    |

## Outputs

| Name | Description |
|------|-------------|
| db\_instance\_address | The address of the RDS instance |
| db\_instance\_arn | The ARN of the RDS instance |
| db\_instance\_endpoint | The connection endpoint |
| db\_instance\_engine | The database engine |
| db\_instance\_id | The RDS instance ID |
| db\_instance\_name | The database name |
| db\_instance\_password | The master password |
| db\_instance\_port | The database port |
| db\_instance\_resource\_id | The RDS Resource ID of this instance |
| db\_instance\_status | The RDS instance status |
| db\_instance\_username | The master username for the database |
<!-- END_TF_DOCS -->