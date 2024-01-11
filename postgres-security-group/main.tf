data "aws_security_group" "bastion_sg" {
  filter {
    name = "description"
    values = [var.bastion_sg_description]
  }
}

locals {
  source =  concat(var.cidr_blocks, [data.aws_security_group.bastion_sg.id]) 
}

# ===================================================== #
# - - - - - - -  VPC SECURITY GROUP - - - - - - - - - - #
# ===================================================== #

resource "aws_security_group" "security_group" {
    vpc_id = var.vpc_id
    name = var.name
    tags = {
      Name = var.name
    }

    lifecycle {
    create_before_destroy = true
  } 
}

resource "aws_vpc_security_group_egress_rule" "egress" {
 security_group_id = aws_security_group.security_group.id
  ip_protocol   = -1
  cidr_ipv4  = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = toset(local.source)
    description = "inbound rule of the security group" 
    security_group_id = aws_security_group.security_group.id
    from_port = 5432
    to_port = 5432
    ip_protocol = "tcp"
    cidr_ipv4 = substr(each.key,0,2) != "sg" ? each.key : null
    referenced_security_group_id = substr(each.key,0,2) == "sg" ? each.key : null
}


  
 