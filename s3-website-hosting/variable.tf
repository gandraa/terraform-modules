variable "bucket_name" {
  type        = string
  description = "Name of static we hosting S3 bucket."
}

variable "s3_force_destroy" {
  default     = false
  type        = bool
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`)."
}

variable "dns_zone_name" {
  type        = string
  description = "Name of the hosted zone to contain the record."
}

variable "record_name" {
  type        = string
  description = "Name of DNS record."
}

variable "ssl_support_method" {
  type        = string
  default     = "sni-only"
  description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
}

variable "minimum_protocol_version" {
  type        = string
  default     = "TLSv1"
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
}
variable "import_cert" {
  type        = string
  default     = ""
  description = "Specify If Cloudfront Have To Use Imported Certificate. If Not Specify Then Terraform Will Create And Use Aws Managed Acm certificate "
}

variable "signing_behavior" {
  type        = string
  default     = "always"
  description = "siging behavior for the cloud front (alway or never or overwrite)."
}

variable "signing_protocol" {
  type        = string
  default     = "sigv4"
  description = "siginng protocol for the cloudfront."
}

variable "product_name" {
  type        = string
  description = "name of the product"
}

variable "cloudfront_functions" {
  type = map(object({
    name    = string
    comment = string
    publish = bool
    code    = string
  }))
  default = {}
}

variable "error_codes" {
  type        = list(number)
  default     = [404, 400, 403]
  description = "Error codes for which custom_error_response to 200 ./index.html will be created"
}