
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| apply_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | string | `false` | no |
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| audit_log | Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged | string | `true` | no |
| auto_minor_version_upgrade | Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions | string | `false` | no |
| broker_name | The name of the broker | string | `mq` | no |
| chamber_parameter_name | Format to store parameters in SSM, for consumption with chamber | string | `/%s/%s` | no |
| chamber_service | SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default. | string | `` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage` and `attributes` | string | `-` | no |
| deployment_mode | The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ | string | `ACTIVE_STANDBY_MULTI_AZ` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| engine_type | The type of broker engine. Currently, Amazon MQ supports only ActiveMQ | string | `ActiveMQ` | no |
| engine_version | The version of the broker engine. Currently, Amazon MQ supports only 5.15.0 or 5.15.6. | string | `5.15.0` | no |
| general_log | Enables general logging via CloudWatch | string | `true` | no |
| host_instance_type | The broker's instance type. e.g. mq.t2.micro or mq.m4.large | string | `mq.t2.micro` | no |
| kms_key_id | KMS key id used to encrypt SSM parameters | string | `` | no |
| maintenance_day_of_week | The day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY | string | `SUNDAY` | no |
| maintenance_time_of_day | The time, in 24-hour format. e.g. 02:00 | string | `03:00` | no |
| maintenance_time_zone | The time zone, in either the Country/City format, or the UTC offset format. e.g. CET | string | `UTC` | no |
| mq_admin_password | Admin password | string | `` | no |
| mq_admin_user | Admin username | string | `` | no |
| mq_application_password | Application password | string | `` | no |
| mq_application_user | Application username | string | `` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| overwrite_ssm_parameter | Whether to overwrite an existing SSM parameter | string | `true` | no |
| publicly_accessible | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. | string | `false` | no |
| security_groups | List of security groups to be allowed to connect to the ActiveMQ instance | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| subnet_ids | List of VPC subnet IDs | list | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| vpc_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin_username |  |
| application_username |  |
| broker_arn |  |
| broker_id |  |
| primary_ampq_ssl_endpoint |  |
| primary_console_url |  |
| primary_ip_address |  |
| primary_mqtt_ssl_endpoint |  |
| primary_ssl_endpoint |  |
| primary_stomp_ssl_endpoint |  |
| primary_wss_endpoint |  |
| secondary_ampq_ssl_endpoint |  |
| secondary_console_url |  |
| secondary_ip_address |  |
| secondary_mqtt_ssl_endpoint |  |
| secondary_ssl_endpoint |  |
| secondary_stomp_ssl_endpoint |  |
| secondary_wss_endpoint |  |

