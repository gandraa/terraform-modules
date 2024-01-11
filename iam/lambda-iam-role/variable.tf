variable "role_name" {
  type        = string
  description = "The name of the role."
}

variable "policy_arn" {
  type        = set(string)
  description = "A unique identifier for the policy."
}

variable "assume_role_policy_file" {
  type        = string
  description = "The file that contains the policy information."
}

variable "customer_managed_policy_name" {
  type        = string
  description = "The name of the customized policy"
  default     = ""
}

variable "customer_managed_policy_file" {
  type        = string
  description = "The name of file that contains the customized policy."
  default     = null
}
