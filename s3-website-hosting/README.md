<!-- BEGIN_TF_DOCS -->



## Modules

| Name | Source | Version |
|------|--------|---------|
| cert\_dns | [../common-cert](../common-cert) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cloud_front_s3_distribuution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.cloudfront_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.dns_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.web_host_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_cloud_front_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block_publick_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.enable_website_hosting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [null_resource.cloudfront_invalidation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_cloudfront_cache_policy.caching_optimized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_response_headers_policy.security_headers_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of static we hosting S3 bucket. | `string` | n/a | yes |
| cloudfront\_functions | Map of objects to create optional cloudfront functions (Maximum of 2). Objects should have keys 'viewer-request' or 'viewer-response' tying them to corresponding event types. | <pre>map(object({<br>    name    = string<br>    comment = string<br>    publish = bool<br>    code    = string<br>  }))</pre> | `{}` | no |
| dns\_zone\_name | Name of the hosted zone to contain the record. | `string` | n/a | yes |
| error\_codes | Error codes for which custom\_error\_response to 200 ./index.html will be created. | `list(number)` | <pre>[<br>  404,<br>  400,<br>  403<br>]</pre> | no |
| import\_cert | Specify If Cloudfront Have To Use Imported Certificate. If Not Specify Then Terraform Will Create And Use Aws Managed Acm certificate | `string` | `""` | no |
| minimum\_protocol\_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1"` | no |
| product\_name | name of the product | `string` | n/a | yes |
| record\_name | Name of DNS record. | `string` | n/a | yes |
| s3\_force\_destroy | Delete all objects from the bucket so that the bucket can be destroyed without error (e.g. `true` or `false`). | `bool` | `false` | no |
| signing\_behavior | siging behavior for the cloud front (alway or never or overwrite). | `string` | `"always"` | no |
| signing\_protocol | siginng protocol for the cloudfront. | `string` | `"sigv4"` | no |
| ssl\_support\_method | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. | `string` | `"sni-only"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_domain\_name | Domain name corresponding to the bucket |
| cloudfront | Arn of the cloudfront distribution |
| dns\_domain\_name | Domain name corresponding to the distribution. |
| s3\_bucket\_website\_endpoint | S3 bucket static website endpoint. |
<!-- END_TF_DOCS -->