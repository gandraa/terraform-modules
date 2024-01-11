<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [helm_release.helm_deployment](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart\_path | Path to the chart to install. | `string` | n/a | yes |
| chart\_version | Version of the chart to install. | `string` | `""` | no |
| create\_namespace | Create the namespace if it does not yet exist. | `bool` | `false` | no |
| k8s\_namespace | K8s namespace to install the service in. | `string` | n/a | yes |
| repository | Repository to the chart to install. | `string` | n/a | yes |
| service\_name | Name for the helm release. | `string` | n/a | yes |
| value\_map | Map of values to use. Needs to be of type map (or object). | `map(string)` | `{}` | no |
| values\_file\_path | Relative path to the values file from the helm module. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| release | Helm release values as Terraform object |
<!-- END_TF_DOCS -->