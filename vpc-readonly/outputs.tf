locals {
  public_subnet_availability_zone = {
    for subnet in data.aws_subnet.public : subnet.id => subnet.availability_zone_id
  }
  private_subnet_availability_zone = {
    for subnet in data.aws_subnet.private : subnet.id => subnet.availability_zone_id
  }


  private_secondary_subnet_availability_zone = {
    for subnet in data.aws_subnet.private_secondary : subnet.id => subnet.availability_zone_id
  }
  public_secondary_subnet_availability_zone = {
    for subnet in data.aws_subnet.public_secondary : subnet.id => subnet.availability_zone_id
  }
}

output "vpc_id" {
  value = data.aws_vpcs.main.ids[0]
}

#
# Outputs for private subnet
#

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "private_subnets_perAz" {
  value = {
    for subnet in data.aws_subnet.private : subnet.availability_zone => subnet.id
  }
}

output "private_subnets_perAzId" {
  value = {
    for subnet in data.aws_subnet.private : subnet.availability_zone_id => subnet.id
  }
}


output "private_subnets_routtable_perAzId" {
  value = {
    for routetable in data.aws_route_table.private : lookup(local.private_subnet_availability_zone, routetable.subnet_id) => routetable.route_table_id
  }
}

#
# Outputs for public subnets
#
output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "public_subnets_perAz" {
  value = {
    for subnet in data.aws_subnet.public : subnet.availability_zone => subnet.id
  }
}

output "public_subnets_perAzId" {
  value = {
    for subnet in data.aws_subnet.public : subnet.availability_zone_id => subnet.id
  }
}

output "public_subnets_routtable_perAzId" {
  value = {
    for routetable in data.aws_route_table.public : lookup(local.public_subnet_availability_zone, routetable.subnet_id) => routetable.route_table_id
  }
}


#
# Secondary subnets - Public
#
output "public_secondary_subnet_ids" {
  value = data.aws_subnets.public_secondary.ids
}



output "public_secondary_subnets_perAz" {
  value = {
    for subnet in data.aws_subnet.public_secondary : subnet.availability_zone => subnet.id
  }
}

output "public_secondary_subnets_perAzId" {
  value = {
    for subnet in data.aws_subnet.public_secondary : subnet.availability_zone_id => subnet.id
  }
}


output "public_secondary_subnets_routtable_perAzId" {
  value = {
    for routetable in data.aws_route_table.public_secondary : lookup(local.public_secondary_subnet_availability_zone, routetable.subnet_id) => routetable.route_table_id
  }
}

#
# Secondary subnets - Private
#
output "private_secondary_subnet_ids" {
  value = data.aws_subnets.private_secondary.ids
}



output "privatae_secondary_subnets_perAz" {
  value = {
    for subnet in data.aws_subnet.private_secondary : subnet.availability_zone => subnet.id
  }
}

output "private_secondary_subnets_perAzId" {
  value = {
    for subnet in data.aws_subnet.private_secondary : subnet.availability_zone_id => subnet.id
  }
}


output "private_secondary_subnets_routtable_perAzId" {
  value = {
    for routetable in data.aws_route_table.private_secondary : lookup(local.private_secondary_subnet_availability_zone, routetable.subnet_id) => routetable.route_table_id
  }
}

output "eks_nodegroup_securitygroup_ids" {
  value = data.aws_security_groups.eks_security_group.ids
}

output "eks_securitygroup_ids" {
  value = data.aws_security_groups.eks_security_group.ids
}

output "rds_securitygroup_ids" {
  value = data.aws_security_groups.rds_security_group.ids
}
