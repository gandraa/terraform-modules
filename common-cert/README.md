<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cert\_domain | Domain name for which the certificate should be issued. | `string` | n/a | yes |
| cert\_region | Region to request certificate. | `string` | `null` | no |
| cert\_subject\_alternative\_names | Set of domains that should be SANs in the issued certificate. | `set(string)` | n/a | yes |
| dns\_validation\_private\_zone | Flag to define the zone type. | `bool` | `false` | no |
| dns\_zone\_name | Name of DNS zone. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cert\_arn | n/a |
<!-- END_TF_DOCS -->