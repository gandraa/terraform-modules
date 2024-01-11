# ===================================================== #
# - - - - - - - - -  Data Section   - - - - - - - - - - #
# ===================================================== #
data "aws_route53_resolver_rules" "share_rules" {
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
}

# ===================================================== #
# - - - Create a Route53 Resolver rule association  - - #
# ===================================================== #
resource "aws_route53_resolver_rule_association" "rule_association" {
  for_each          = toset(data.aws_route53_resolver_rules.share_rules.resolver_rule_ids)
  resolver_rule_id  = each.value
  vpc_id           = var.vpc_id
}
