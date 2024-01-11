variable "topic_name" {
  type        = string
  description = "Name of the SNS topic."
}

variable "endpoint" {
  type        = string
  description = "Endpoint to send data to."
}

variable "protocol" {
  type        = string
  description = "Protocol to use."
}