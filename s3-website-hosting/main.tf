# ===================================================== #
# - - - - - - - - -  Locals Section     - - - - - - - - #
# ===================================================== #
locals {
  domain_name  = join(".", compact([var.record_name, var.dns_zone_name]))
  product_name = var.product_name
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

# ===================================================== #
# - - - - - - - - -  Data Section   - - - - - - - - - - #
# ===================================================== #
data "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "Managed-SecurityHeadersPolicy"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone_name
  private_zone = false
}


# ===================================================== #
# - - - - - S3 Static Website Hosting Bucket  - - - - - #
# ===================================================== #
resource "aws_s3_bucket" "web_host_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_website_configuration" "enable_website_hosting" {
  bucket = aws_s3_bucket.web_host_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "block_publick_access" {
  bucket                  = aws_s3_bucket.web_host_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_cloud_front_access" {
  bucket = aws_s3_bucket.web_host_bucket.id
  policy = templatefile("${path.module}/../assets/policies/cloud_front_s3_website_access.json", { resources = "${aws_s3_bucket.web_host_bucket.arn}/*", cloudfront = "${aws_cloudfront_distribution.cloud_front_s3_distribuution.arn}" })

}


# ===================================================== #
# - - - - - -  Custom SSL Certificate - - - - - - - - - #
# ===================================================== #
module "cert_dns" {
  source = "../common-cert"
  providers = {
    aws = aws.acm
  }
  count                          = var.import_cert == "" ? 1 : 0
  cert_domain                    = local.domain_name
  cert_subject_alternative_names = ["*.${local.domain_name}"]
  dns_zone_name                  = var.dns_zone_name
}

# ===================================================== #
# - - - - - Cloud Front Distribution  - - - - - - - - - #
# ===================================================== #
resource "aws_cloudfront_distribution" "cloud_front_s3_distribuution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.product_name} cloudfront distribution"
  default_root_object = "index.html"


  aliases = [local.domain_name]

  origin {
    domain_name              = aws_s3_bucket.web_host_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.web_host_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

    connection_attempts = 3
    connection_timeout  = 10
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.web_host_bucket.id

    compress                   = true
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers_policy.id
    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id

    viewer_protocol_policy = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.cloudfront_functions
      content {
        event_type   = function_association.key
        function_arn = aws_cloudfront_function.cloudfront_function[function_association.key].arn
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.import_cert == "" ? module.cert_dns[0].cert_arn : var.import_cert
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  dynamic "custom_error_response" {
    for_each = var.error_codes
    content {
      error_code            = custom_error_response.value
      response_code         = 200
      error_caching_min_ttl = 10
      response_page_path    = "/index.html"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

# ===================================================== #
# - - - - - - - - Create CF Invalidation  - - - - - - - #
# ===================================================== #
resource "null_resource" "cloudfront_invalidation" {
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.cloud_front_s3_distribuution.id} --paths /* "
  }
  depends_on = [aws_cloudfront_distribution.cloud_front_s3_distribuution]
  triggers = {
    always_run = "${timestamp()}"
  }
}

# ===================================================== #
# - - - - - - - - Route 53 Records  - - - - - - - - - - #
# ===================================================== #
resource "aws_route53_record" "dns_records" {
  for_each        = toset(["A", "AAAA"])
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
  name            = var.record_name
  allow_overwrite = false
  type            = each.key

  alias {
    name                   = try(aws_cloudfront_distribution.cloud_front_s3_distribuution.domain_name, "")
    zone_id                = try(aws_cloudfront_distribution.cloud_front_s3_distribuution.hosted_zone_id, "")
    evaluate_target_health = false
  }
}


# ===================================================== #
# - - - - Cloud front origin access control  - -  - - - #
# ===================================================== #
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${local.product_name} Origin Access Control Policy"
  description                       = "Origin Access Control Policy for cloudfront distribution"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = var.signing_behavior
  signing_protocol                  = var.signing_protocol
}

# ===================================================== #
# - - - - - - - - Cloud front functions - - - - - - - - #
# ===================================================== #
resource "aws_cloudfront_function" "cloudfront_function" {
  for_each = var.cloudfront_functions
  name     = each.value.name
  runtime  = "cloudfront-js-1.0"
  comment  = each.value.comment
  publish  = each.value.publish
  code     = each.value.code
}