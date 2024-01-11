output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster."
  value       = replace(aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")
}

output "cluster_ca_certificate" {
  description = "Cluster CA Certificate."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "The endpoint to reach the cluster."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_securit_group_id" {
  description = "The security group of the cluster."
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "cluster_kms_key_id" {
  description = "The KMS key to encrypt the cluster configuration."
  value       = aws_kms_key.cluster_key.*.key_id != [] ? element(aws_kms_key.cluster_key.*.key_id, 0) : ""
}

output "cluster_kms_key_alias" {
  description = "The KMS key alias to encrypt the cluster configuration."
  value       = join("", aws_kms_alias.cluster_key_alias.*.arn)
}

output "version" {
  description = "Version of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.version
}
