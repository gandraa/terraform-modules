variable "eks_environment" {
  type        = string
  description = "Environment name(e.g. cbplus)."
}

variable "eks_account" {
  type        = string
  description = "Name of account to create EKS cluster."
}

variable "eks_region" {
  type        = string
  description = "Region to create EKS cluster."
}

variable "eks_iam_custom_policies" {
  type        = list(map(string))
  description = "Custom policies to be attached to EKS Node Group Role."
}

variable "eks_iam_managed_policies" {
  type        = list(string)
  description = "Managed policies to be attached to EKS Node Group Role."
  default = []
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of EKS cluster."
}

variable "eks_version" {
  type        = string
  default     = "1.21"
  description = "Kubernetes version of the EKS cluster"
}

variable "eks_ami_version" {
  type        = string
  default     = null
  description = "AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version."
}

variable "eks_node_group_azs" {
  type        = list(map(string))
  description = "AZ to the Node Group."
}

variable "node_asg_desired_size" {
  type        = number
  default     = 2
  description = "Desired capacity of Node Group ASG."
}

variable "node_asg_max_size" {
  type        = number
  default     = 3
  description = "Maximum size of Node Group ASG. Set to at least 1 greater than NodeAutoScalingGroupDesiredCapacity."
}

variable "node_asg_min_size" {
  type        = number
  default     = 1
  description = "Minimum size of Node Group ASG."
}

variable "kubernetes_taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default     = []
  description = "List of `key`, `value`, `effect` objects representing Kubernetes taints."
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument."
  default     = {}
}

variable "node_volume_size" {
  type        = number
  default     = 20
  description = "Node volume size."
}

variable "node_instance_type" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "EC2 instance type for the node instances."
}

variable "imds_v1_disabled" {
  type        = bool
  default     = false
  description = "Access instance metadata from a running instance using IMDS."
}

variable "name_prefix" {
  type        = string
  description = "prefix of the node group name"
  default     = ""
}

variable "cni_version" {
  type    = string
  default = ""
}