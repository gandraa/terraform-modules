# ===================================================== #
# - - - - - - - -  AWS VPC CNI Setup -  - - - - - - - - #
# ===================================================== #

# ============================================================= #
#      Attache helm annotations to aws-node Kubernetes resource #
#      to allow managed them via helm                           #
# ============================================================= #

resource "null_resource" "annotate_nodes" {
  triggers = {
    "sha256" = filesha256("./assets/addVpcCniToHelmRelease.sh")
  }

  provisioner "local-exec" {
    command = <<EOH
              chmod 0755 ${path.cwd}/assets/addVpcCniToHelmRelease.sh
              ${path.cwd}/assets/addVpcCniToHelmRelease.sh
              EOH
  }
}

locals {
  subnets = {
    for az, subnetId in var.subnets_per_az : az => {
      id = subnetId,
      securityGroups : var.eks_node_security_group_ids
    }
  }
}

# ============================================================= #
#      Install aws-vpc-cni via Helm Chart                       #
# ============================================================= #
resource "helm_release" "aws-vpc-cni" {
  name      = "aws-vpc-cni"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-vpc-cni"

  version    = "${var.chart_version}"

  atomic = true

  values = [yamlencode({
    "crd" = {
      "create" = false
    }

    "originalMatchLabels" = true

    "init" = {
      "image" = {
        "region" = "${var.aws_region}"
      }
    }

    "image" = {
      "region" = "${var.aws_region}"
    }

    "nodeAgent" = {
      "image" = {
        "region" = "${var.aws_region}"
      }
    }

    "eniConfig" = {
      "create"  = true
      "region"  = "${var.aws_region}"
      "subnets" = local.subnets
    }

    "env" = {
      "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG" = true
      "ENI_CONFIG_LABEL_DEF"               = "topology.kubernetes.io/zone"
    }
    })
  ]
}
