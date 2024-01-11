variable "eks_environment" {
  type        = string
  description = "Environment name(e.g. cbplus)."
}

variable "eks_account" {
  type        = string
  description = "Name of account to create EKS cluster."
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of EKS cluster."
}

variable "eks_role_name" {
  type        = string
  description = "Name of IAM Role to EKS control plane."
}

variable "eks_version" {
  type        = string
  description = "Version of EKS cluster."
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}
variable "cluster_encryption_config_kms_key_id" {
  type        = string
  default     = ""
  description = "KMS Key ID to use for cluster encryption config."
}

variable "cluster_encryption_config_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to enable Cluster Encryption Configuration"
}

variable "cluster_encryption_config_resources" {
  type        = list(any)
  default     = ["secrets"]
  description = "Cluster Encryption Config Resources to encrypt, e.g. ['secrets']"
}

variable "cluster_enable_key_rotation" {
  type        = bool
  default     = true
  description = "Cluster Encryption Config KMS Key Resource argument - enable kms key rotation"
}

variable "vpc_id" {
  description = "VPC to create cluster."
  type        = string
}

variable "enable_private_access" {
  description = "Enable private access to EKS cluster"
  type        = bool
  default     = true
}

variable "vpc_subnet_ids" {
  description = "Subnets to be attached to EKS."
  type        = list(any)
}

variable "eks_iam_custom_policies" {
  type        = list(map(string))
  description = "Custom policies to be attached to EKS Cluster Role."
  default     = []
}
