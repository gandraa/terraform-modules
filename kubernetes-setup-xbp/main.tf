provider "archive" {}

locals {
  istio = {
    namespace_system = "istio-system"
    helm_repository = "https://istio-release.storage.googleapis.com/charts"
  }
}

data "template_file" "values_istiod" {
  template = file("${path.module}/values/istiod-values.tpl")
  vars = {
    "pilot_minReplicas" = var.istio.pilot_minReplicas
    "namespace" = local.istio.namespace_system
  }
}

data "template_file" "values_gateway_loadbalancer" {
  template = file("${path.module}/values/gateway-loadbalancer-values.tpl")
  vars = {
    "gatewayMinReplicas" = var.istio.ingressgateway_minReplicas
    "mtlsGatewayUrl" = var.xbp-servicemesh_configOverride.mtlsGateway.url
  }
}

data "template_file" "values_gateway_nodeport" {
  template = file("${path.module}/values/gateway-nodeport-values.tpl")
  vars = {
    "gatewayMinReplicas" = var.istio.ingressgateway_minReplicas
  }
}

resource "kubernetes_namespace" "service-mesh-namespace" {
  metadata {
    annotations = {
        name = local.istio.namespace_system
    }
    name = local.istio.namespace_system
  }
}

resource "helm_release" "istio_base" {
  name = "istio-base"
  repository = local.istio.helm_repository
  chart = "base"
  version = var.istio.chart_version
  namespace = kubernetes_namespace.service-mesh-namespace.metadata[0].name
  atomic = true
}

resource "helm_release" "istio_istiod" {
  depends_on = [
    helm_release.istio_base
  ]

  name = "istiod"
  repository = local.istio.helm_repository
  chart = "istiod"
  version = var.istio.chart_version
  namespace = kubernetes_namespace.service-mesh-namespace.metadata[0].name
  atomic = true

  values = [data.template_file.values_istiod.rendered]
}

resource "helm_release" "istio_gateway_loadbalancer" {
  depends_on = [
    helm_release.istio_istiod
  ]

  name = "istio-ingressgateway"
  repository = local.istio.helm_repository
  chart = "gateway"
  version = var.istio.chart_version
  namespace = kubernetes_namespace.service-mesh-namespace.metadata[0].name
  atomic = true

  values = [data.template_file.values_gateway_loadbalancer.rendered]
}

resource "helm_release" "istio_gateway_nodeport" {
  depends_on = [
    helm_release.istio_istiod
  ]

  name = "istio-ingressgateway-nodeport"
  repository = local.istio.helm_repository
  chart = "gateway"
  version = var.istio.chart_version
  namespace = kubernetes_namespace.service-mesh-namespace.metadata[0].name
  atomic = true

  values = [data.template_file.values_gateway_nodeport.rendered]
}

data "archive_file" "xbp-servicemesh-chart" {
  type        = "zip"
  source_dir  = "${var.rootPath}/../kubernetes/apps/xbp-servicemesh/"
  output_path = "xbp-servicemesh-chart.zip"
}

resource "helm_release" "xbp-servicemesh" {
  depends_on = [
    helm_release.istio_gateway_loadbalancer,
    helm_release.istio_gateway_nodeport
  ]

  name      = "xbp-servicemesh"
  namespace = "default"
  atomic    = true

  chart = "${var.rootPath}/../kubernetes/apps/xbp-servicemesh"
  values = [yamlencode(merge({
    istio = {
      namespace = local.istio.namespace_system
      albGateway = {
        annotations = {
          "alb.ingress.kubernetes.io/certificate-arn" = var.xbp-servicemesh_configOverride.albGateway.certArn
          "external-dns.alpha.kubernetes.io/hostname" = var.xbp-servicemesh_configOverride.albGateway.url
        }
      }
    }
    mtls = {
      apigee = {
        allowed_envs = var.xbp-servicemesh_allowedApigeeEnvs[var.env]
        trusted_subjectAltnames = var.xbp-servicemesh_trustedSubjectAltnames[var.env]
      }
    }
    }, var.xbp-servicemesh_configOverride))
  ]

  set {
    name  = "checksum"
    value = data.archive_file.xbp-servicemesh-chart.output_sha
  }

  set {
    name  = "env"
    value = var.env
  }
}
