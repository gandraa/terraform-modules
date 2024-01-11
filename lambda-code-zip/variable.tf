variable "type" {
  type = string
  description = " The type of archive to generate."
}

variable "source_dir" {
  type        = string
  description = "Package entire contents of this directory into the archive."
}

variable "output_file_mode" {
  type        = string
  description = "String that specifies the octal file mode for all archived files."
}

variable "output_path" {
  type        = string
  description = "The output of the archive file."
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket to put the file in."
}

variable "s3_key" {
  type        = string
  description = "Name of the object once it is in the bucket."
}

variable "object_source" {
  type        = string
  description = "Path to a file that will be read and uploaded as raw bytes for the object content."
}