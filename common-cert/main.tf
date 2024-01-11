# ===================================================== #
# - - - - - - - - -  Data Section   - - - - - - - - - - #
# ===================================================== #
data "aws_region" "current" {}

data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone_name != null ? var.dns_zone_name : var.cert_domain
  private_zone = var.dns_validation_private_zone
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ===================================================== #
# - - - - - - -   ACM certificate     - - - - - - - - - #
# ===================================================== #
resource "aws_acm_certificate" "cert" {
  domain_name               = var.cert_domain
  subject_alternative_names = var.cert_subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_record : record.fqdn]
}

# ===================================================== #
# - - - - - - -    DNS Record   - - - - - - - - - - - - #
# ===================================================== #
resource "aws_route53_record" "dns_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
}