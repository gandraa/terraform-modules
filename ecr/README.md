<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ecr\_parameters | List of ecr parameters. | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| registry\_id | Registry ID. |
| repository\_name | Name of repository. |
| repository\_url | URL of repository. |
<!-- END_TF_DOCS -->