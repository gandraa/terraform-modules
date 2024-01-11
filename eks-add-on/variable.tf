variable "eks_cluster_name" {
  description = "EKS Cluster Name."
  type        = string
}

variable "eks_cluster_addon" {
  description = "EKS Addons Details."
  type = list(object({
    addon_name               = string
    service_account_role_arn = string
    addon_version            = string
  }))
  default = []

}

variable "eks_version" {
  description = "EKS Cluster Version."
  type        = string
}

variable "account_name" {
  description = "AWS Account Name."
  type        = string
}

