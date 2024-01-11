variable "product" {
  type        = string
  description = "Environment name(e.g. common)."
}

variable "use_cluster_identifier_prefix" {
  type        = bool
  default     = false
  description = "Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix."
}

variable "cluster_identifier" {
  type        = string
  description = "The name of the aurora rds cluster."
}

variable "family" {
  type        = string
  description = "The family of the DB parameter group (e.g. aurora-postgresql14)."
  default     = null
}

variable "parameters" {
  type        = list(map(string))
  description = "A list of DB parameter maps to apply."
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs."
  default     = []
}

variable "engine" {
  type        = string
  description = "The database engine to use (e.g. postgres)."
  default     = null
}

variable "engine_version" {
  type        = string
  description = "The engine version to use."
  default     = null
}

variable "db_cluster_instance_class" {
  type        = string
  description = "The instance type of the Aurora RDS instances. Can be checked here https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html ."
  default     = null
}

variable "allocated_storage" {
  type        = string
  description = "The allocated storage in gigabytes."
  default     = null
}

variable "storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  default     = null
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB instance is encrypted."
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used."
  default     = null
}

variable "database_name" {
  type        = string
  description = "The DB name to create. If omitted, no database is created initially."
  default     = null
}

variable "master_username" {
  type        = string
  description = "Username for the master DB user."
  default     = null
}

variable "port" {
  default     = 5432
  description = "Port the database should listen on."
  type        = number
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs."
  default     = []
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "preferred_maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'."
  default     = null
}

variable "preferred_backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window."
  default     = null
}

variable "backup_retention_period" {
  type        = number
  description = "The days to retain backups for."
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  default     = []
}

variable "deletion_protection" {
  type        = bool
  description = "The database can't be deleted when this value is set to true."
  default     = false
}

variable "create_cloudwatch_log_group" {
  type        = bool
  description = "Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`."
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "The number of days to retain CloudWatch logs for the DB instance."
  default     = 7
}

variable "cloudwatch_log_group_kms_key_id" {
  type        = string
  description = "The ARN of the KMS Key to use when encrypting log data"
  default     = null
}

variable "timeouts" {
  type        = map(string)
  description = "Updated Terraform resource management timeouts. Applies to `aws_rds_cluster` in particular to permit resource management times."
  default     = {}
}

variable "skip_final_snapshot" {
  type        = bool
  description = "determine whether skip_final_snapshot should be added or not"
  default     = false
}

variable "final_snapshot_identifier" {
  type        = string
  description = "value fo the final identifier"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created. RDS automatically assigns 3 AZs if less than 3 AZs are configured, which will show as a difference requiring resource recreation next Terraform apply. We recommend specifying 3 AZs or using the lifecycle configuration block ignore_changes argument if necessary. A maximum of 3 AZs can be configured."
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cluster_instances_count" {
  type        = number
  description = "Number of cluster instances."
  default     = 1
}

variable "cluster_instance_class" {
  type        = string
  description = "The instance type of the Aurora RDS instances. Can be checked here https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html ."
  default     = "db.t3.medium"
}

variable "aurora_ca_certificate" {
  type        = string
  description = "Certificate Authority for Aurora"
  default     = "rds-ca-rsa2048-g1"
}

variable "use_legacy_ssm_path" {
  type        = bool
  description = "Whether to use legacy path for SSM. 'False' avoids naming conflicts when deploying multiple aurora instances for same product"
  default     = true
}