output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket_website_configuration.enable_website_hosting.website_endpoint
  description = "S3 bucket static website endpoint."
}

output "dns_domain_name" {
  value       = local.domain_name
  description = "Domain name corresponding to the distribution."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.web_host_bucket.bucket_domain_name
  description = "Domain name corresponding to the bucket"
}

output "cloudfront" {
  value       = aws_cloudfront_distribution.cloud_front_s3_distribuution.arn
  description = "Arn of the cloudfront distribution"
}