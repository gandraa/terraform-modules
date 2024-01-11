output "bucket_name" {
  value       = aws_s3_object.object.bucket
  description = "Name of the s3 object."
}

output "s3_key" {
  value       = aws_s3_object.object.key
  description = "Key of the s3 object."
}