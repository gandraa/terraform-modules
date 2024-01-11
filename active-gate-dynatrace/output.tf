output "active_gate_ec2_instance_id" {
  description = "InstanceId of the newly created EC2 instance"
  value       = aws_instance.active_gate_ec2_instance.id
}

output "active_gate_role" {
  description = "IAM role of the newly created EC2 instance"
  value       = aws_iam_role.active_gate_role.arn
}