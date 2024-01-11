# ===================================================== #
# - - - - - - - - -  Locals Section     - - - - - - - - #
# ===================================================== #
locals {
  kms_arn = var.storage_encrypted && var.kms_key_id == null ? (
    join("", aws_kms_key.docdb.*.arn)
  ) : var.kms_key_id
}
# ===================================================== #
# - - - - - - - - - - DOCDB CLUSTER - - - - - - - - - - #
# ===================================================== #
resource "random_password" "docdb" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  special     = false
}

resource "aws_docdb_cluster" "docdb" {
  engine         = var.engine
  engine_version = var.engine_version

  cluster_identifier = var.identifier
  port               = var.db_port
  availability_zones = var.availability_zones

  master_username = var.master_username
  master_password = random_password.docdb.result

  backup_retention_period      = var.retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  apply_immediately            = var.apply_immediately

  final_snapshot_identifier = lower(var.identifier)
  skip_final_snapshot       = var.skip_final_snapshot
  deletion_protection       = var.deletion_protection

  storage_encrypted = var.storage_encrypted
  kms_key_id        = local.kms_arn

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids          = [join("", aws_security_group.docdb[*].id)]
  db_subnet_group_name            = aws_docdb_subnet_group.docdb.id
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb.id

  lifecycle {
    prevent_destroy = true
  }
}

# ===================================================== #
# - - - - - - - - - - DOCDB INSTANCES - - - - - - - - - #
# ===================================================== #
resource "aws_docdb_cluster_instance" "docdb" {
  count              = var.cluster_size
  identifier         = "${var.identifier}-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class

  apply_immediately            = var.apply_immediately
  preferred_maintenance_window = var.preferred_maintenance_window

  engine                     = var.engine
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  enable_performance_insights = var.enable_performance_insights

  tags = {
    "Name" = var.identifier
  }

  lifecycle {
    prevent_destroy = true
  }
}
# ===================================================== #
# - - - - - - - - DOCDB PARAMETER GROUP - - - - - - - - #
# ===================================================== #
resource "aws_docdb_cluster_parameter_group" "docdb" {
  name        = "${var.identifier}-docdb"
  description = "${var.identifier} DocDB cluster parameter group"
  family      = var.cluster_parameter_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ===================================================== #
# - - - - - - - - - DOCDB SUBNET GROUP  - - - - - - - - #
# ===================================================== #
resource "aws_docdb_subnet_group" "docdb" {
  name        = "${var.identifier}-docdb"
  description = "Allowed subnets for ${var.identifier} instances"
  subnet_ids  = var.subnet_ids
}

# ===================================================== #
# - - - - - - - - - DOCDB SECURITY GROUP - - - - - - -  #
# ===================================================== #
resource "aws_security_group" "docdb" {
  name        = "${var.identifier}-docdb"
  description = "Security Group for ${var.identifier} DocumentDB cluster"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress_from_sg" {
  count                    = length(var.allowed_security_groups)
  type                     = "ingress"
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = join("", aws_security_group.docdb[*].id)
}
# ===================================================== #
# - - - - - - - - - DOCDB STORAGE KMS Keys - - - - - -  #
# ===================================================== #
resource "aws_kms_key" "docdb" {
  count               = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  description         = format("%s DocDB Storage Encryption KMS Key", upper(var.identifier))
  enable_key_rotation = true
}

resource "aws_kms_alias" "docdb" {
  count         = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  name          = "alias/${var.identifier}-docdb"
  target_key_id = join("", aws_kms_key.docdb.*.key_id)
}
# ===================================================== #
# - - - - - - - DOCDB SSM Parameter Store - - - - - - - #
# ===================================================== #

resource "aws_ssm_parameter" "docdb_username" {
  name  = "/infra/${var.product}/docdb/${var.identifier}/id"
  value = try(aws_docdb_cluster.docdb.master_username, "")
  type  = "String"
}

resource "aws_ssm_parameter" "docdb_password" {
  name  = "/infra/${var.product}/docdb/${var.identifier}/secret"
  value = try(aws_docdb_cluster.docdb.master_password, "")
  type  = "String"
}