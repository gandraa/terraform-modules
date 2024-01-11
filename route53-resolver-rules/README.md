<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_route53_resolver_rule_association.rule_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_resolver_rules.share_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc\_id | The ID of the VPC that you want to associate the resolver rule with. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| resolver\_rule\_ids | n/a |
<!-- END_TF_DOCS -->