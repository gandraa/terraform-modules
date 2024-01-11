variable "rootPath" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "kube_context" {
  type = string
}

variable "env" {
  type = string
}

variable "istio" {
  type = object({
    ingressgateway_minReplicas = number
    pilot_minReplicas          = number
    chart_version              = string
  })

  default = {
    ingressgateway_minReplicas = 2
    pilot_minReplicas          = 2
    chart_version              = null
  }
}

variable "jaegertracing" {
  type = object({
    cassandra_cluster_size     = number
    cassandra_persistence_size = string
  })

  default = {
    cassandra_cluster_size     = 3
    cassandra_persistence_size = null
  }
}

variable "xbp-servicemesh_allowedApigeeEnvs" {
  type = map(any)

  default = {
    dev   = ["test"]
    stage = ["test", "prod"]
    prod  = ["prod"]
  }
}

variable "xbp-servicemesh_configOverride" {
  type = object({
    mtlsGateway = object({
      url = string

    })
    albGateway = object({
      url     = string
      certArn = string
    })
  })
}

variable "xbp-servicemesh_trustedSubjectAltnames" {
  type = map

  default = {
    dev = [ "dev.test.gls-group.net", "dev.test.api.gls-group.net" ]
    stage = [ "qas.test.gls-group.net", "qas.test.api.gls-group.net", "sandbox.prod.gls-group.net", "sandbox.prod.api.gls-group.net" ]
    prod = [ "prod.prod.gls-group.net", "prod.prod.api.gls-group.net" ]
  }
}