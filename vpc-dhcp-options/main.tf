# ===================================================== #
# - - - - - - -  AWS VPC DHCP OPTIONS - - - - - - - - - #
# ===================================================== #
data "aws_vpc_dhcp_options" "main_dhcp_option" {
  filter {
    name   = "value"
    values = var.dhcp_option_filter
  }
}

# ===================================================== #
# - - - -  AWS VPC DHCP OPTIONS ASSOCIATION - - - - - - #
# ===================================================== #
resource "aws_vpc_dhcp_options_association" "vpc_dhcp_association" {
  vpc_id          = var.vpc_id
  dhcp_options_id = data.aws_vpc_dhcp_options.main_dhcp_option.id
}