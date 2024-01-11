variable "role_name" {
  type        = string
  description = "The name of the role."
}

variable "customer_managed_policy_name" {
  type        = string
  description = "The name of the customized policy"
}

variable "customer_managed_policy_file" {
  type        = string
  description = "The name of file that contains the customized policy."
}

variable "dynatrace_monitoring_account_id" {
  type        = number
  description = "Dynatrace monitoring account ID."
}

variable "dynatrace_external_id" {
  type        = string
  description = "Dynatrace external ID."
}
