variable "eventbridge_name" {
  type        = string
  description = "Name of the EventBridge."
}

variable "eventbridge_description" {
  type        = string
  description = "Description for the EventBridge."
}

variable "parameter_names" {
  type        = list
  description = "List of parameters that will watched for the EventBridge rule."
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "namespace" {
  type        = string
  description = "The namespace where the user intend to update the secrets"
}

variable "function_name" {
  type        = string
  description = "The name for the lambda function will be created"
}

variable "handler" {
  type        = string
  description = "Lambda Function Handler"
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  type        = string
  description = "Lambda Function Runtime"
  default     = "python3.10"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket that contains the python file used on the lambda function"
}

variable "s3_key" {
  type        = string
  description = "Path to the python file which will be used on the labmda funcion"
}

variable "role_arn" {
  type        = string
  description = "Default role which will be used by the labmda funcion to access the cluster"
}