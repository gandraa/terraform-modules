# ===================================================== #
# - - - - - - - - -  Locals Section     - - - - - - - - #
# ===================================================== #
locals {
  cluster_identifier        = var.use_cluster_identifier_prefix ? null : var.cluster_identifier
  cluster_identifier_prefix = var.use_cluster_identifier_prefix ? "${var.cluster_identifier}-" : null

  service_name = var.use_legacy_ssm_path ? "${var.engine}-aurora" : var.cluster_identifier
  resource     = var.use_legacy_ssm_path ? var.master_username : var.engine

  description_parameter_group = format("%s parameter group", var.cluster_identifier)

  kms_arn = var.storage_encrypted && var.kms_key_id == null ? (
    join("", aws_kms_key.rds_key.*.arn)
  ) : var.kms_key_id
}

# ===================================================== #
# - - - - - - - - - - RDS SUBNET GROUP  - - - - - - - - #
# ===================================================== #
resource "aws_db_subnet_group" "subnet_group" {
  name        = local.cluster_identifier
  name_prefix = local.cluster_identifier_prefix
  subnet_ids  = var.subnet_ids
}

# ===================================================== #
# - - - - - - - - - - RDS PARAMETER GROUP   - - - - - - #
# ===================================================== #
resource "aws_rds_cluster_parameter_group" "aurora_rds_parameter_group" {
  name        = local.cluster_identifier
  name_prefix = local.cluster_identifier_prefix
  description = local.description_parameter_group
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ===================================================== #
# - - - - - - RDS STORAGE KMS Keys - - - - - - - - -    #
# ===================================================== #
resource "aws_kms_key" "rds_key" {
  count               = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  description         = format("%s RDS Storage Encryption KMS Key", upper(var.cluster_identifier))
  enable_key_rotation = true
}

resource "aws_kms_alias" "rds_key_alias" {
  count         = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  name          = "alias/${var.cluster_identifier}-rds"
  target_key_id = join("", aws_kms_key.rds_key.*.key_id)
}

# ===================================================== #
# - - - - - - - - - -  CloudWatch Log Group - - - - - - #
# ===================================================== #
resource "aws_cloudwatch_log_group" "rds_logs" {
  for_each = toset([for log in var.enabled_cloudwatch_logs_exports : log if var.create_cloudwatch_log_group])

  name              = "/aws/rds/instance/${var.cluster_identifier}/${each.value}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
}

# ===================================================== #
# - - - - - - - - - - AWS Aurora RDS  - - - - - - - - - #
# ===================================================== #
resource "random_password" "generic_pass" {
  length           = 10
  special          = true
  min_special      = 2
  override_special = "!#$%^&*()-_=+[]{}<>:?"
  keepers = {
    pass_version = 1
  }
}

resource "aws_ssm_parameter" "db_master_pass" {
  name  = join("/", compact(["/infra", var.product, local.service_name, local.resource, "password"]))
  type  = "SecureString"
  value = random_password.generic_pass.result
}

resource "aws_rds_cluster" "aurora_rds_cluster" {
  cluster_identifier        = local.cluster_identifier
  cluster_identifier_prefix = local.cluster_identifier_prefix

  engine         = var.engine
  engine_version = var.engine_version

  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = local.kms_arn

  database_name   = var.database_name
  master_username = var.master_username
  master_password = random_password.generic_pass.result
  port            = var.port

  availability_zones              = var.availability_zones
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_rds_parameter_group.id

  allow_major_version_upgrade     = var.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  final_snapshot_identifier       = var.final_snapshot_identifier
  skip_final_snapshot             = var.skip_final_snapshot
  apply_immediately               = var.apply_immediately
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  tags = {
    "Name" = local.cluster_identifier
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.cluster_instances_count
  identifier         = "aurora-instance-${var.product}-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_rds_cluster.id
  instance_class     = var.cluster_instance_class
  engine             = aws_rds_cluster.aurora_rds_cluster.engine
  engine_version     = aws_rds_cluster.aurora_rds_cluster.engine_version
  ca_cert_identifier = var.aurora_ca_certificate
  apply_immediately  = var.apply_immediately
}