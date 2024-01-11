variable "vpc_id" {
    type = string
    description = "Id of the present vpc"  
}

variable "name" {
    type = string
    description = "name of the security-group"
}

variable "cidr_blocks" {
    type = list(string)
}

variable "bastion_sg_description" {
    type = string
    description = "description of the bastion host security group"
}


