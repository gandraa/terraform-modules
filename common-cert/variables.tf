variable "cert_domain" {
  type        = string
  description = "Domain name for which the certificate should be issued."
}

variable "cert_subject_alternative_names" {
  type        = set(string)
  description = "Set of domains that should be SANs in the issued certificate."
}

variable "dns_validation_private_zone" {
  type        = bool
  default     = false
  description = "Flag to define the zone type."
}

variable "dns_zone_name" {
  type        = string
  description = "Name of DNS zone."
}