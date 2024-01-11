# ===================================================== #
# - - - - - - - - -  Locals Section     - - - - - - - - #
# ===================================================== #
locals {
  identifier        = var.use_identifier_prefix ? null : var.identifier
  identifier_prefix = var.use_identifier_prefix ? "${var.identifier}-" : null

  description_parameter_group = format("%s parameter group", var.identifier)

  kms_arn = var.storage_encrypted && var.kms_key_id == null ? (
    join("", aws_kms_key.rds_key.*.arn)
  ) : var.kms_key_id
}

# ===================================================== #
# - - - - - - - - RDS EVENT SUBSCRIPTION  - - - - - - - #
# ===================================================== #
resource "aws_db_event_subscription" "event_subscription" {
  count            = var.sns_topic == null ? 0 : 1
  name             = var.subscription_name
  sns_topic        = var.sns_topic
  source_type      = var.source_type
  source_ids       = var.source_ids
  event_categories = var.event_categories
}

# ===================================================== #
# - - - - - - - - - - RDS SUBNET GROUP  - - - - - - - - #
# ===================================================== #
resource "aws_db_subnet_group" "subnet_group" {
  name        = local.identifier
  name_prefix = local.identifier_prefix
  subnet_ids  = var.subnet_ids
}

# ===================================================== #
# - - - - - - - - - - RDS PARAMETER GROUP   - - - - - - #
# ===================================================== #
resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = local.identifier
  name_prefix = local.identifier_prefix
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
  description         = format("%s RDS Storage Encryption KMS Key", upper(var.identifier))
  enable_key_rotation = true
}

resource "aws_kms_alias" "rds_key_alias" {
  count         = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  name          = "alias/${var.identifier}-rds"
  target_key_id = join("", aws_kms_key.rds_key.*.key_id)
}
# ===================================================== #
# - - - - - - - - - -  CloudWatch Log Group - - - - - - #
# ===================================================== #
resource "aws_cloudwatch_log_group" "rds_logs" {
  for_each = toset([for log in var.enabled_cloudwatch_logs_exports : log if var.create_cloudwatch_log_group])

  name              = "/aws/rds/instance/${var.identifier}/${each.value}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
}

# ===================================================== #
# - - - - - - - - - - -  AWS RDS  - - - - - - - - - - - #
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
  name  = join("/", compact(["/infra", var.product, var.engine, var.username, "password"]))
  type  = "SecureString"
  value = random_password.generic_pass.result
}

resource "aws_db_instance" "rds_instance" {
  identifier        = local.identifier
  identifier_prefix = local.identifier_prefix

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = local.kms_arn
  ca_cert_identifier    = var.cert_identifier


  db_name  = var.db_name
  username = var.username
  password = random_password.generic_pass.result
  port     = var.port

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.id

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.final_snapshot_identifier

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  tags = {
    "Name" = local.identifier
  }
}