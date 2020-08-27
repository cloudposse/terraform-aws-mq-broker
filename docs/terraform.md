## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_to\_ssm | Adds the admin and application user credentials to SSM. | `bool` | `true` | no |
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `string` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| audit\_log | Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged | `string` | `true` | no |
| auto\_minor\_version\_upgrade | Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions | `string` | `false` | no |
| chamber\_parameter\_name | Format to store parameters in SSM, for consumption with chamber (Requires `add_to_ssm=true`) | `string` | `"/%s/%s"` | no |
| chamber\_service | SSM parameter service name for use with chamber. This is used in chamber\_format where /$chamber\_service/$parameter would be the default (Requires `add_to_ssm=true`) | `string` | `""` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage` and `attributes` | `string` | `"-"` | no |
| deployment\_mode | The deployment mode of the broker. Supported: SINGLE\_INSTANCE and ACTIVE\_STANDBY\_MULTI\_AZ | `string` | `"ACTIVE_STANDBY_MULTI_AZ"` | no |
| engine\_type | The type of broker engine. Currently, Amazon MQ supports only ActiveMQ | `string` | `"ActiveMQ"` | no |
| engine\_version | The version of the broker engine. Currently, Amazon MQ supports only 5.15.0 or 5.15.6. | `string` | `"5.15.0"` | no |
| existing\_security\_groups | List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to true to enable using `existing_security_groups` as Security Groups for the cluster | `list(string)` | `[]` | no |
| general\_log | Enables general logging via CloudWatch | `string` | `true` | no |
| host\_instance\_type | The broker's instance type. e.g. mq.t2.micro or mq.m4.large | `string` | `"mq.t2.micro"` | no |
| kms\_key\_id | KMS key ID used to encrypt SSM parameters (Requires `add_to_ssm=true`) | `string` | `""` | no |
| maintenance\_day\_of\_week | The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY | `string` | `"SUNDAY"` | no |
| maintenance\_time\_of\_day | The maintenance time, in 24-hour format. e.g. 02:00 | `string` | `"03:00"` | no |
| maintenance\_time\_zone | The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET | `string` | `"UTC"` | no |
| mq\_admin\_password | Admin password | `string` | `""` | no |
| mq\_admin\_user | Admin username | `string` | `""` | no |
| mq\_application\_password | Application password | `string` | `""` | no |
| mq\_application\_user | Application username | `string` | `""` | no |
| name | Name of the application | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| overwrite\_ssm\_parameter | Whether to overwrite an existing SSM parameter (Requires `add_to_ssm=true`) | `string` | `true` | no |
| publicly\_accessible | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. | `string` | `false` | no |
| security\_groups | List of security groups to be allowed to connect to the ActiveMQ instance | `list(string)` | `[]` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| subnet\_ids | List of VPC subnet IDs | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(any)` | `{}` | no |
| use\_existing\_security\_groups | Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into | `bool` | `false` | no |
| vpc\_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | `string` | n/a | yes |

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

