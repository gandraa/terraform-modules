variable "name" {
  type        = string
  description = "The name of the document."
}

variable "document_format" {
  description = "The format of the document. "
  type        = string
  default     = "YAML"
}

variable "document_type" {
  description = "The type of the document."
  type        = string
  default     = "Command"
}

variable "target_type" {
  description = "The target type which defines the kinds of resources the document can run on."
  type        = string
  default     = "/AWS::EC2::Instance"
}

variable "version_name" {
  description = "A field specifying the version of the artifact you are creating with the document."
  type        = string
  default     = ""
}

variable "content_file" {
  description = "The JSON or YAML content of the document."
  type        = string
}

variable "team_name" {
  description = "The name of the team that are usging the module."
  type        = string
}

variable "environment" {
  description = "The name of the environment where the module are deployed on."
  type        = string
}

variable "ssm_parameter_variables" {
  description = "The list of ssm parameters."
  type        = list(string)
  default = []
}


variable "value_map" {
  type        = map(string)
  description = "Map of values to use. Needs to be of type map (or object)."
  default     = {}
}

variable "targets" {
  description = "Specify what instance IDs or Tags to apply the document to and has these keys."
  type = object({
    key   = string
    values = list(string)
  })
  default = {
    key = "InstanceIds"
    values = ["*"]
  }
}