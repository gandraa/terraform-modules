data "aws_vpcs" "main" {
  tags = var.vpc_search_tags
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.main.ids
  }

  tags = var.private_subnets_search_tags
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_route_table" "private" {
  for_each = toset(data.aws_subnets.private.ids)

  subnet_id = each.value
}


data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.main.ids
  }

  tags = var.public_subnets_search_tags
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}


data "aws_route_table" "public" {
  for_each = toset(data.aws_subnets.public.ids)

  subnet_id = each.value
}


#
# Secondary subnets - Private
#

data "aws_subnets" "private_secondary" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.main.ids
  }

  tags = var.public_secondary_subnets_search_tags
}
data "aws_subnet" "private_secondary" {
  for_each = toset(data.aws_subnets.private_secondary.ids)
  id       = each.value
}

data "aws_route_table" "private_secondary" {
  for_each = toset(data.aws_subnets.private_secondary.ids)

  subnet_id = each.value
}

#
# Secondary subnets - Public
#

data "aws_subnets" "public_secondary" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpcs.main.ids
  }

  tags = var.public_secondary_subnets_search_tags
}
data "aws_subnet" "public_secondary" {
  for_each = toset(data.aws_subnets.public_secondary.ids)
  id       = each.value
}

data "aws_route_table" "public_secondary" {
  for_each = toset(data.aws_subnets.public_secondary.ids)

  subnet_id = each.value
}

data "aws_security_groups" "eks_security_group" {
  tags = var.eks_security_group_search_tags
}

data "aws_security_groups" "rds_security_group" {
  tags = {
    "aws:cloudformation:logical-id": "RdsSecurityGroupSubnet*"
  }
}