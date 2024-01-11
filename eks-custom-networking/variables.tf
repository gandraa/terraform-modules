variable "aws_region" {
  type        = string
  description = "Region where resources are created."
  default     = "eu-central-1"
}

variable "chart_version" {
  type        = string
  description = "Version of the aws-vpc-cni helm chart."
  default     = "1.2.2"
}

variable "eks_node_security_group_ids" {
  type        = list(string)
  description = "List of Security group ID of EKS nodes."
}

variable "subnets_per_az" {
  type        = map(any)
  description = "List of subnet ID per availability zone."
}