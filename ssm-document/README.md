<!-- BEGIN_TF_DOCS -->




## Resources

| Name | Type |
|------|------|
| [aws_ssm_association.ssm_document_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.ssm_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_parameter.ssm_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| content\_file | The JSON or YAML content of the document. | `string` | n/a | yes |
| document\_format | The format of the document. | `string` | `"YAML"` | no |
| document\_type | The type of the document. | `string` | `"Command"` | no |
| name | The name of the document. | `string` | n/a | yes |
| ssm\_parameter\_variables | The list of ssm parameters. | `list(string)` | `[]` | no |
| target\_type | The target type which defines the kinds of resources the document can run on. | `string` | `"/AWS::EC2::Instance"` | no |
| targets | Specify what instance IDs or Tags to apply the document to and has these keys. | <pre>object({<br>    key   = string<br>    values = list(string)<br>  })</pre> | <pre>{<br>  "key": "InstanceIds",<br>  "values": [<br>    "*"<br>  ]<br>}</pre> | no |
| value\_map | Map of values to use. Needs to be of type map (or object). | `map(string)` | `{}` | no |
| version\_name | A field specifying the version of the artifact you are creating with the document. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| created\_date | The date the document was created. |
| document\_status | "Creating", "Active" or "Deleting". The current status of the document. |
| latest\_version | The latest version of the document. |
| platform\_types | A list of OS platforms compatible with this SSM document. |
<!-- END_TF_DOCS -->