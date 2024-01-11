variable "eks_environment" {
  type        = string
  description = "Environment name(e.g. cbplus)."
}

variable "eks_account" {
  type        = string
  description = "Name of account to create EKS cluster."
}

variable "account_id" {
  type        = string
  description = "AWS account Id."
}

variable "iam_roles" {
  type = list(
    object({
      role_name = string
      namespace = string
      policies = list(object({
        file_name = string
        resources = string
      }))
      managed_policies = list(string)
  }))
  description = "List of IAM Roles."
}

variable "oidc" {
  type        = string
  description = "OIDC of EKS cluster."
}