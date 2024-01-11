# ===================================================== #
# - - - -  EKS Cluster Add-On Version - - - - - - - - - # 
# ===================================================== #
data "aws_eks_addon_version" "latest" {
  for_each           = { for addon in var.eks_cluster_addon : addon.addon_name => addon }
  addon_name         = each.value.addon_name
  kubernetes_version = var.eks_version
  most_recent        = true
}

# ===================================================== #
# - - - - - -   EKS Cluster Add-On  - - - - - - - - - - # 
# ===================================================== #

resource "aws_eks_addon" "eks_cluster_addon" {
  for_each = { for addon in var.eks_cluster_addon : addon.addon_name => addon }

  cluster_name             = var.eks_cluster_name
  addon_name               = each.value.addon_name
  addon_version            = var.account_name == "prod" ? each.value.addon_version : data.aws_eks_addon_version.latest[each.key].version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = each.value.service_account_role_arn
}
