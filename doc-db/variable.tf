variable "product" {
  description = "The name of the XB+ product, eg. 'xcds' to construct path to AWS SSM Parameter Store"
  type        = string
  default     = ""
}

variable "identifier" {
  description = "The name of the DocDB cluster."
  type        = string
  default     = ""
}

variable "cluster_size" {
  type        = number
  description = "Number of DB instances to create in the cluster"
}

variable "instance_class" {
  type        = string
  description = "The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs"
}

variable "db_port" {
  type        = number
  default     = 27017
  description = "DocumentDB port"
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of EC2 Availability Zones that instances in the DB cluster can be created in."
}

variable "master_username" {
  type        = string
  description = "An alphanumeric string that defines the login ID for the user."
}

variable "engine" {
  type        = string
  default     = "docdb"
  description = "The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb`"
}

variable "engine_version" {
  type        = string
  default     = "5.0.0"
  description = "The version number of the database engine to use"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Specifies whether any minor engine upgrades will be applied automatically to the DB instance during the maintenance window or not"
  default     = false
}

variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "preferred_backup_window" {
  type        = string
  default     = "00:00-02:00"
  description = "Daily time range during which the backups happen"
}

variable "preferred_maintenance_window" {
  type        = string
  default     = "Mon:22:00-Mon:23:00"
  description = "The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "A value that indicates whether the DB cluster has deletion protection enabled"
  default     = true
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_id`, `storage_encrypted` needs to be set to `true`"
  default     = ""
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
}


variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: `audit`, `error`, `general`, `slowquery`"
  default     = []
}

variable "enable_performance_insights" {
  type        = bool
  description = "Specifies whether to enable Performance Insights for the DB Instance."
  default     = false
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)
  default     = []
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB parameters to apply"
}

variable "cluster_parameter_family" {
  type        = string
  default     = "docdb5.0"
  description = "The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Groups to be allowed to connect to the DocumentDB cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}