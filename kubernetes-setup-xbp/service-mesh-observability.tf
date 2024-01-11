data "aws_ssm_parameter" "azureClientId" {
  name = "infra.authservice.azuread.client_id"
}
data "aws_ssm_parameter" "azureClientSecret" {
  name = "infra.authservice.azuread.client_secret"
}

resource "kubernetes_secret" "kiali" {
  depends_on = [
    kubernetes_namespace.service-mesh-namespace
  ]
  metadata {
    name        = "kiali"
    namespace   = local.istio.namespace_system
    annotations = {}
    labels      = {}
  }

  data = {
    oidc-secret = data.aws_ssm_parameter.azureClientSecret.value
  }
}

module "service-mesh-observability" {
  depends_on = [
    kubernetes_secret.kiali
  ]

  source = "../service-mesh-observability"

  jaegertracing = {
    namespace = local.istio.namespace_system
    configOverrideYaml = yamlencode({
      cassandra = {
        persistence = {
          enabled = var.jaegertracing.cassandra_persistence_size != null ? true : false
          size    = var.jaegertracing.cassandra_persistence_size
        }
        config = {
          cluster_size = var.jaegertracing.cassandra_cluster_size
        }
      }
    })
  }

  kiali = {
    namespace = local.istio.namespace_system
    configOverrideYaml = yamlencode({
      cr = {
        spec = {
          auth = {
            strategy = "openid"
            openid = {
              client_id      = nonsensitive(data.aws_ssm_parameter.azureClientId.value)
              issuer_uri     = "https://login.microsoftonline.com/e6170c30-202d-4926-b525-b8b882873f3b/v2.0"
              scopes         = ["openid", "profile", "email"]
              api_token      = "id_token"
              disable_rbac   = true
              username_claim = "email"
            }
          }
          deployment = {
            view_only_mode = true
          }
        }
      }
    })
  }
}
