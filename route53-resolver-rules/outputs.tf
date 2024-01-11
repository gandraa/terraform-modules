output "resolver_rule_ids" {
  description = "The ID of the rules will be associated to the VPC"
  value = values(aws_route53_resolver_rule_association.rule_association)[*].resolver_rule_id
}