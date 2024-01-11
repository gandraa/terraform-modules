output "bastion_ec2_instance_id" {
  description = "InstanceId of the newly created EC2 instance"
  value       = aws_instance.bastion_ec2_instance.id
}

output "bastion_instance_role" {
  description = "IAM role of the newly created EC2 instance"
  value       = aws_iam_role.bastion_instance_role.arn
}