# ===================================================== #
# - - - - - - - -  XBP EKS Cluster Setup - - - - - - - #
# ===================================================== #

# ===================================================== #
# - - - - - - - - -   Local Section   - - - - - - - - - #
# ===================================================== #
locals {

  cluster_encryption_config = {
    resources = var.cluster_encryption_config_resources

    provider_key_arn = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? (
      join("", aws_kms_key.cluster_key.*.arn)
    ) : var.cluster_encryption_config_kms_key_id
  }
}

# ===================================================== #
# - - - - - -  XB+ EKS Control Plain  - - - - - - - - - #
# ===================================================== #
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_control_plane_role.arn

  vpc_config {
    subnet_ids              = var.vpc_subnet_ids
    endpoint_private_access = var.enable_private_access
    security_group_ids      = [aws_security_group.control_plane_security_group.id]
  }

  dynamic "encryption_config" {
    for_each = var.cluster_encryption_config_enabled ? [local.cluster_encryption_config] : []
    content {
      resources = lookup(encryption_config.value, "resources")
      provider {
        key_arn = lookup(encryption_config.value, "provider_key_arn")
      }
    }
  }

  version                   = var.eks_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attachments_cluster,
    aws_iam_role_policy_attachment.eks_policy_attachments_service
  ]
}

# ===================================================== #
# - - - - - - EKS Cliuster KMS Keys  - - - - - - - -    #
# ===================================================== #
resource "aws_kms_key" "cluster_key" {
  count               = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  description         = "EKS Cluster Encryption Config KMS Key"
  enable_key_rotation = var.cluster_enable_key_rotation
}

resource "aws_kms_alias" "cluster_key_alias" {
  count         = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  name          = "alias/eks-kms-key"
  target_key_id = join("", aws_kms_key.cluster_key.*.key_id)

}
# ===================================================== #
# - - - - - -  IAM Control Plain Role  - - - - - - - -  #
# ===================================================== #
resource "aws_iam_role" "eks_control_plane_role" {
  name        = var.eks_role_name
  description = "IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

# ===================================================== #
# - - - - - -  IAM Managed Policy Attachment - - - - -  #
# ===================================================== #
resource "aws_iam_role_policy_attachment" "eks_policy_attachments_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachments_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_control_plane_role.name
}

# ===================================================== #
# - - - - - -   Custom EKS Cluster Policies  - - - - - - - #
# ===================================================== #
resource "aws_iam_policy" "eks_cluster_policies" {
  for_each = { for policy in var.eks_iam_custom_policies : policy.file_name => policy.resources }
  name     = replace(each.key, ".json", "")
  policy   = templatefile("${path.module}/policies/${each.key}", { resources = each.value })
}

# ===================================================== #
# - - - - - -  IAM Custom Policy Attachment - - - - -   #
# ===================================================== #
resource "aws_iam_role_policy_attachment" "eks_custom_policy_attachments" {
  for_each   = aws_iam_policy.eks_cluster_policies
  policy_arn = each.value.arn
  role       = aws_iam_role.eks_control_plane_role.name
}


# ===================================================== #
# - - - - - -  Security Group Control Plain  - - - - -  #
# ===================================================== #
resource "aws_security_group" "control_plane_security_group" {
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id
}