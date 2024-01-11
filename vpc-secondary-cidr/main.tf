# ===================================================== #
# - - - - - - - - -  Data Section     - - - - - - - - - #
# ===================================================== #
data "aws_availability_zones" "available" {}

# ===================================================== #
# - - - - - - -  Create Secondary IP Range  - - - - - - #
# ===================================================== #
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
}

# ===================================================== #
# - - - - - - -  Create Secondary Subnets   - - - - - - #
# ===================================================== #
resource "null_resource" "cidr_subnets" {
  count = length(data.aws_availability_zones.available.names)
  triggers = {
    subnet = cidrsubnet(
      var.cidr_block,
      ceil(length(data.aws_availability_zones.available.names) / 2),
      count.index,
    )
  }
}

resource "aws_subnet" "main-subnet" {
  for_each = toset(null_resource.cidr_subnets.*.triggers.subnet)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[index(null_resource.cidr_subnets.*.triggers.subnet, each.value)]
  cidr_block           = each.value
  vpc_id               = var.vpc_id

  tags = merge({
    Name             = "${var.account_name}-${var.environment}-secondary-private-${data.aws_availability_zones.available.names[index(null_resource.cidr_subnets.*.triggers.subnet, each.value)]}.subnet"
    AvailabilityZone = "${data.aws_availability_zones.available.names[index(null_resource.cidr_subnets.*.triggers.subnet, each.value)]}"
    Tier             = "private"
    Type             = "secondary"
  }, var.tags)

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]
}

# ===================================================== #
# - - - - - - -  Assign Subnets to RT   - - - - - - - - #
# ===================================================== #
resource "aws_route_table_association" "route_tables" {
  for_each = resource.aws_subnet.main-subnet
  subnet_id      = each.value.id
  route_table_id = var.route_tables[each.value.availability_zone_id]
}
