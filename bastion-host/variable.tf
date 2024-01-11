variable "instance_name" {
  description       = "EC2 Instance Name. Lowercase letters!"
  type              = string
  default           = null
  validation {
   condition = can(regex("^[a-z-]+$", var.instance_name))
   error_message = "EC2 Instance Name must use lowercase letters."
  }
}

variable "instance_type" {
  description = "Server EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "account_name" {
  description = "The stage for deployment"
  type        = string
}

variable "subnet_id" {
  description       = "EC2 SubnetID"
  type              = string
  default           = null
}

variable "vpc_id" {
  description       = "VPC"
  type              = string
  default           = null
}

variable "volume_size_sda" {
  description     = "Volume Size for the root volume."
  type            = number
  default         = 20
}

variable "blobstore_s3_bucket" {
  description       = "S3 bucket that contains the security agent installation files"
  type              = string
  default           = "aws-automation-blobstore"
}

variable "postgres_sg_names" {
    type = list(string)
    description = "names of the postgres host security groups"
    default = []
}

variable "cidr_blocks" {
    type = list(string)
    default = []
}