variable "instance_name" {
  description       = "EC2 Instance Name. Lowercase letters!"
  type              = string
  default           = null
  validation {
   condition = can(regex("^[a-z-]+$", var.instance_name))
   error_message = "EC2 Instance Name must use lowercase letters."
  }
}

variable "instance_type" {
  description = "Server EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "account_name" {
  description = "The stage for deployment"
  type        = string
}

variable "subnet_id" {
  description       = "EC2 SubnetID"
  type              = string
  default           = null
}

variable "vpc_id" {
  description       = "VPC"
  type              = string
  default           = null
}

variable "volume_size_sda" {
  description     = "Volume Size for the root volume."
  type            = number
  default         = 20
}

variable "cidr_blocks" {
    type = list(string)
    default = []
    description = "Allowed inbound/outbound CIDR Range."
}

variable "dynatrace_url" {
    type = string
    description = "Dynatrace address."
}

variable "dynatrace_network_zone" {
    type = string
    description = "Dynatrace network zone."
}

variable "dynatrace_active_gate_group" {
    type = string
    description = "Dynatrace AG group."
}

variable "downoad_token_path" {
    type = string
    description = "Path to API download token in SSM."
}