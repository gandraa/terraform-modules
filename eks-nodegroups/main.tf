# ===================================================== #
# - - - - - - - - - XB+ EKS Node Group - - - - - - - -  #
# ===================================================== #

# ===================================================== #
# - - - - - - - - -   Local Section   - - - - - - - - - #
# ===================================================== #
locals {
  all_partition = {
    "aws"        = "ec2.amazonaws.com"
    "aws-us-gov" = "ec2.amazonaws.com"
    "aws-cn"     = "ec2.amazonaws.com.cn"
    "aws-iso"    = "ec2.c2s.ic.gov"
    "aws-iso"    = "ec2.sc2s.sgov.gov"
  }

  aws_service = lookup(local.all_partition, data.aws_partition.current.partition)

  eks_iam_managed_policies = setunion(var.eks_iam_managed_policies, toset([
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonSSMManagedInstanceCore",
    "service-role/AmazonEBSCSIDriverPolicy"
  ]))

  filtered_azs = [for azs in var.eks_node_group_azs : "${var.eks_region}${azs.az}"]

}
# ===================================================== #
# - - - - - - - - -  Data Section   - - - - - - - - - - #
# ===================================================== #
data "aws_partition" "current" {}

data "aws_ssm_parameter" "latest_eks_ami_version" {
  name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/release_version"
}

data "aws_availability_zones" "azs" {
  filter {
    name   = "zone-name"
    values = local.filtered_azs
  }
}

data "aws_ec2_instance_type_offering" "az_instance_type" {
  for_each = toset(data.aws_availability_zones.azs.names)

  filter {
    name   = "instance-type"
    values = var.node_instance_type
  }

  filter {
    name   = "location"
    values = [each.value]
  }

  location_type = "availability-zone"

  preferred_instance_types = var.node_instance_type
}

# ===================================================== #
# - - - - - - - -  EKS SSH Key  - - - - - - - - - - - - #
# ===================================================== #
resource "aws_key_pair" "eks_ssh_key" {
  key_name   = join("-", compact([var.eks_environment, "infrastructure", "eks", "node", "key", var.name_prefix, var.eks_account, "${random_string.random.result}"]))
  public_key = file("${path.module}/../assets/keys/eks-node-key-${var.eks_account}.pub")
}

# ===================================================== #
# - - - - - - -  IAM Node Group Role  - - - - - - - - - #
# ===================================================== #
resource "aws_iam_role" "eks_node_group_role" {
  name = join("-", compact([var.eks_environment, "infrastructure", "eks", "cluster", "node", var.name_prefix, var.eks_account, "${random_string.random.result}"]))

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "${local.aws_service}"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

# ===================================================== #
# - - - - - -   Custom EKS Node Policies  - - - - - - - #
# ===================================================== #
resource "aws_iam_policy" "eks_node_group_policies" {
  for_each = { for policy in var.eks_iam_custom_policies : policy.file_name => policy.resources }
  name     = join("-", compact([replace(each.key, ".json", ""), var.name_prefix, "${random_string.random.result}"]))
  policy   = templatefile("${path.module}/../assets/policies/${each.key}", { resources = each.value })
}

# ===================================================== #
# - - - - - -   Attach IAM Policies to Role - - - - - - #
# ===================================================== #
resource "aws_iam_role_policy_attachment" "eks_managed_policy_attachments" {
  for_each   = local.eks_iam_managed_policies
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/${each.value}"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_custom_policy_attachments" {
  for_each   = aws_iam_policy.eks_node_group_policies
  policy_arn = each.value.arn
  role       = aws_iam_role.eks_node_group_role.name
}

# ===================================================== #
# - - - - - - -    EKS Node Group - - - - - - - - - - - #
# ===================================================== #
resource "random_string" "random" {
  length  = 5
  special = false
}

resource "aws_eks_node_group" "eks_node_groups" {
  for_each = { for az_subnet in var.eks_node_group_azs : az_subnet.az => az_subnet.private_subnet }
  node_group_name = join("-", compact([var.eks_environment, "eks", "node", var.name_prefix, var.eks_account,
  "${var.eks_region}${each.key}", "${random_string.random.result}"]))
  cluster_name    = var.eks_cluster_name
  release_version = var.eks_ami_version != null ? var.eks_ami_version : nonsensitive(data.aws_ssm_parameter.latest_eks_ami_version.value)
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [each.value]

  scaling_config {
    desired_size = var.node_asg_desired_size
    max_size     = var.node_asg_max_size
    min_size     = var.node_asg_min_size
  }

  launch_template {
    id      = lookup(aws_launch_template.ec2_node_templates, "${var.eks_region}${each.key}").id
    version = lookup(aws_launch_template.ec2_node_templates, "${var.eks_region}${each.key}").latest_version
  }

  dynamic "taint" {
    for_each = var.kubernetes_taints
    content {
      key    = taint.value["key"]
      value  = taint.value["value"]
      effect = taint.value["effect"]
    }
  }

  labels = var.kubernetes_labels

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_managed_policy_attachments
  ]
}

# ===================================================== #
# - - - - - -   EC2 Template - Node Group - - - - - - - #
# ===================================================== #
resource "aws_launch_template" "ec2_node_templates" {
  for_each      = { for az, details in data.aws_ec2_instance_type_offering.az_instance_type : az => details.instance_type }
  name          = join("-", compact([var.eks_environment, "eks", "node", "template", var.name_prefix, var.eks_account, each.key, "${random_string.random.result}"]))
  instance_type = each.value
  key_name      = aws_key_pair.eks_ssh_key.key_name
  user_data = base64encode(templatefile("${path.module}/../assets/scripts/ec2_bash.sh", {
    eks_cluster_name     = var.eks_cluster_name,
    cni_version          = var.cni_version
  }))
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.node_volume_size
      volume_type           = "gp2"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = join("-", compact([var.eks_environment, "eks", "node", var.name_prefix, var.eks_account, each.key]))
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.imds_v1_disabled ? "required" : "optional"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "disabled"
  }
}