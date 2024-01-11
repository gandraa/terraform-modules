output "dhcp_option_set_id" {
  description = "DHCP option set ID"
  value = data.aws_vpc_dhcp_options.main_dhcp_option.id
}

output "aws_vpc_dhcp_options_association_id" {
  description = "The ID of the DHCP Options Set Association"
  value = aws_vpc_dhcp_options_association.vpc_dhcp_association.id
}
