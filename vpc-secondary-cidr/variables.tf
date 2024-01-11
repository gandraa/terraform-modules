variable "account_name" {
  type        = string
  description = "Name of the account in which the subnets are created"
}
variable "environment" {
  type        = string
  description = "Name of the environment in which the subnets are created"
}

variable "aws_region" {
  type        = string
  description = "Region where resources are created."
  default     = "eu-central-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to add the secondary range."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block of the VPC."
  default     = "100.64.0.0/16"
}

variable "route_tables" {
  type        = map(any)
  description = "Map of route tables for each availability zone which are attach to the created subnets. e..g euc1-az1 --> routeTableID"
  default     = {}
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to the resources."
  default     = {}
}
