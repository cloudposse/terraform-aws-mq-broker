<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.0 |
| null | >= 2.0 |
| random | >= 2.2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |
| random | >= 2.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| allowed\_cidr\_blocks | List of CIDR blocks that are allowed ingress to the broker's Security Group created in the module | `list(string)` | `[]` | no |
| allowed\_security\_groups | List of security groups to be allowed to connect to the broker instance | `list(string)` | `[]` | no |
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| audit\_log\_enabled | Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged | `bool` | `true` | no |
| auto\_minor\_version\_upgrade | Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions | `bool` | `false` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| deployment\_mode | The deployment mode of the broker. Supported: SINGLE\_INSTANCE and ACTIVE\_STANDBY\_MULTI\_AZ | `string` | `"ACTIVE_STANDBY_MULTI_AZ"` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| encryption\_enabled | Flag to enable/disable Amazon MQ encryption at rest | `bool` | `true` | no |
| engine\_type | Type of broker engine, `ActiveMQ` or `RabbitMQ` | `string` | `"ActiveMQ"` | no |
| engine\_version | The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details | `string` | `"5.15.14"` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| existing\_security\_groups | List of existing Security Group IDs to place the broker into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the broker | `list(string)` | `[]` | no |
| general\_log\_enabled | Enables general logging via CloudWatch | `bool` | `true` | no |
| host\_instance\_type | The broker's instance type. e.g. mq.t2.micro or mq.m4.large | `string` | `"mq.t3.micro"` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| kms\_mq\_key\_arn | AWS KMS key used for Amazon MQ encryption | `string` | `"aws/mq"` | no |
| kms\_ssm\_key\_arn | AWS KMS key used for SSM encryption | `string` | `"alias/aws/ssm"` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| maintenance\_day\_of\_week | The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY | `string` | `"SUNDAY"` | no |
| maintenance\_time\_of\_day | The maintenance time, in 24-hour format. e.g. 02:00 | `string` | `"03:00"` | no |
| maintenance\_time\_zone | The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET | `string` | `"UTC"` | no |
| mq\_admin\_password | Admin password | `string` | `null` | no |
| mq\_admin\_user | Admin username | `string` | `null` | no |
| mq\_application\_password | Application password | `string` | `null` | no |
| mq\_application\_user | Application username | `string` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| overwrite\_ssm\_parameter | Whether to overwrite an existing SSM parameter | `bool` | `true` | no |
| publicly\_accessible | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets | `bool` | `false` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| ssm\_parameter\_name\_format | SSM parameter name format | `string` | `"/%s/%s"` | no |
| ssm\_path | SSM path | `string` | `"mq"` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| subnet\_ids | List of VPC subnet IDs | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| use\_aws\_owned\_key | Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) for Amazon MQ encryption that is not in your account | `bool` | `true` | no |
| use\_existing\_security\_groups | Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the broker into | `bool` | `false` | no |
| vpc\_id | VPC ID to create the broker in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_username | AmazonMQ admin username |
| application\_username | AmazonMQ application username |
| broker\_arn | AmazonMQ broker ARN |
| broker\_id | AmazonMQ broker ID |
| primary\_amqp\_ssl\_endpoint | AmazonMQ primary AMQP+SSL endpoint |
| primary\_console\_url | AmazonMQ active web console URL |
| primary\_ip\_address | AmazonMQ primary IP address |
| primary\_mqtt\_ssl\_endpoint | AmazonMQ primary MQTT+SSL endpoint |
| primary\_ssl\_endpoint | AmazonMQ primary SSL endpoint |
| primary\_stomp\_ssl\_endpoint | AmazonMQ primary STOMP+SSL endpoint |
| primary\_wss\_endpoint | AmazonMQ primary WSS endpoint |
| secondary\_amqp\_ssl\_endpoint | AmazonMQ secondary AMQP+SSL endpoint |
| secondary\_console\_url | AmazonMQ secondary web console URL |
| secondary\_ip\_address | AmazonMQ secondary IP address |
| secondary\_mqtt\_ssl\_endpoint | AmazonMQ secondary MQTT+SSL endpoint |
| secondary\_ssl\_endpoint | AmazonMQ secondary SSL endpoint |
| secondary\_stomp\_ssl\_endpoint | AmazonMQ secondary STOMP+SSL endpoint |
| secondary\_wss\_endpoint | AmazonMQ secondary WSS endpoint |

<!-- markdownlint-restore -->
