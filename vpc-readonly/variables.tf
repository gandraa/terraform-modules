variable "vpc_search_tags" {
  type = map(any)
  default = {
    application = "cbplus"
  }
}

variable "public_subnets_search_tags" {
  type = map(any)
  default = {
    Name = "*Public*"
  }
}

variable "private_subnets_search_tags" {
  type = map(any)
  default = {
    Name = "*Private*"
  }
}


variable "private_secondary_subnets_search_tags" {
  type = map(any)
  default = {
    Name = "*private*"
    Type = "secondary"
  }
}


variable "public_secondary_subnets_search_tags" {
  type = map(any)
  default = {
    Name = "*private*"
    Type = "secondary"
  }
}

variable "eks_security_group_search_tags" {
  type = map(any)
    
  default = {
    "aws:eks:cluster-name" = "*"
  }
}