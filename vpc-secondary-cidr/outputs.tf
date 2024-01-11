

output "private_subnet_ids" {
  value = [
    for subnet in aws_subnet.main-subnet : subnet.id
  ]
}

output "private_subnets_perAzName" {
  value = {
    for subnet in aws_subnet.main-subnet : subnet.availability_zone => subnet.id
  }
}

output "private_subnets_perAz" {
  value = {
    for subnet in aws_subnet.main-subnet : subnet.availability_zone_id => subnet.id
  }
}

output "private_subnets_arns" {
  value = [
    for subnet in aws_subnet.main-subnet : subnet.arn
  ]
}