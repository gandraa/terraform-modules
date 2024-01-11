variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "aws_account_id" {
  type        = string
  description = "The ID of the current account."
}

variable "account_name" {
  type        = string
  description = "The name of the current account."
}

variable "aws_region" {
  type        = string
  description = "The default region."
}

variable "dynatrace_environment_url" {
  description = "URL to Dynatrace environment"
  type        = string
}

variable "verify_ssl_target_activegate" {
  description = "If false, expect target ActiveGate to have a self-signed SSL certificate and do not verify its validity"
  type        = bool
}

variable "max_log_content_length" {
  type    = number
  default = 65536
  validation {
    condition     = var.max_log_content_length >= 20 && var.max_log_content_length <= 65536
    error_message = "max_log_content_length must be between 20 and 65536"
  }
}

variable "lambda_source_dir" {
  type        = string
  description = "Package entire contents of this directory into the archive."
}

variable "lambda_output_path" {
  type        = string
  description = "The output of the archive file."
}

variable "log_group_name" {
  type        = list(string)
  description = "The list of loggroups to create the subscription"
}
