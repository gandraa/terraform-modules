variable "service_name" {
  type        = string
  description = "Name for the helm release."
}

variable "repository" {
  type        = string
  default     = ""
  description = "Repository to the chart to install."
}

variable "chart_path" {
  type        = string
  description = "Path to the chart to install."
}

variable "chart_version" {
  type        = string
  default     = ""
  description = "Version of the chart to install."
}

variable "k8s_namespace" {
  type        = string
  description = "K8s namespace to install the service in."
}

variable "values_file_path" {
  type        = string
  description = "Relative path to the values file from the helm module."
}

variable "value_map" {
  type        = map(string)
  default     = {}
  description = "Map of values to use. Needs to be of type map (or object)."
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "Create the namespace if it does not yet exist."
}

variable "always_upgrade" {
  type        = bool
  default     = false
  description = "Should the Helm-Chart always be upgraded, no matter if Terraform detects a difference. Can be helpfull for image-tag latest."
}

variable "dependency_update" {
  type        = bool
  default     = false
  description = "dependency_update should be false as default, and only set to true in xbp-monitoring to install prometheus-msteams, loki dependencies"
}