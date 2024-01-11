# ===================================================== #
# - - - - - - - -  EKS Helm Installations - - - - - - - #
# ===================================================== #
resource "random_id" "timestamp" {
  count = var.always_upgrade ? 1 : 0
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 8
}

resource "helm_release" "helm_deployment" {  
  name             = var.service_name
  repository       = var.repository
  chart            = var.chart_path
  version          = var.chart_version
  namespace        = var.k8s_namespace
  atomic           = true
  create_namespace = var.create_namespace
  dependency_update = var.dependency_update

  values = [
    file("${var.values_file_path}")
  ]

  set {
    name = "timestamp"
    value = (var.always_upgrade ? random_id.timestamp[0].hex : "default")
  }

  dynamic "set" {
    for_each = var.value_map

    content {
      name  = set.key
      value = set.value
    }
  }
}