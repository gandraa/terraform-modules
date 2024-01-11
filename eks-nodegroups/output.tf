output "node_group_role" {
  description = "Name of the worker nodes IAM role."
  value       = aws_iam_role.eks_node_group_role.arn
}

output "eks_node_group_names" {
  description = "EKS Node Group names."
  value       = values(aws_eks_node_group.eks_node_groups)[*].node_group_name
}