variable "vpc_id" {
  description       = "ID of the present VPC in which the association will be created on"
  type              = string
}

variable "dhcp_option_filter" {
  description       = "List of custom filters: name and value"
  type              = list(string)
}