variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
  default     = false
}

variable "deployment_mode" {
  type        = string
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
  default     = "ACTIVE_STANDBY_MULTI_AZ"
}

variable "engine_type" {
  type        = string
  description = "Type of broker engine, `ActiveMQ` or `RabbitMQ`"
  default     = "ActiveMQ"
}

variable "engine_version" {
  type        = string
  description = "The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
  default     = "5.17.6"
}

variable "host_instance_type" {
  type        = string
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
  default     = "mq.t3.micro"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
  default     = false
}

variable "general_log_enabled" {
  type        = bool
  description = "Enables general logging via CloudWatch"
  default     = true
}

variable "audit_log_enabled" {
  type        = bool
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged"
  default     = true
}

variable "maintenance_day_of_week" {
  type        = string
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
  default     = "SUNDAY"
}

variable "maintenance_time_of_day" {
  type        = string
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
  default     = "03:00"
}

variable "maintenance_time_zone" {
  type        = string
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
  default     = "UTC"
}

variable "mq_admin_user" {
  type        = list(string)
  description = "Admin username"
  default     = []
}

variable "mq_admin_password" {
  type        = list(string)
  description = "Admin password"
  default     = []
  sensitive   = true
}

variable "mq_application_user" {
  type        = list(string)
  description = "Application username"
  default     = []
}

variable "mq_application_password" {
  type        = list(string)
  description = "Application password"
  default     = []
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to create the broker in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "ssm_parameter_name_format" {
  type        = string
  description = "SSM parameter name format"
  default     = "/%s/%s"
}

variable "ssm_path" {
  type        = string
  description = "The first parameter to substitute in `ssm_parameter_name_format`"
  default     = "mq"
}

variable "mq_admin_user_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Admin username"
  default     = "mq_admin_username"
}

variable "mq_admin_password_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Admin password"
  default     = "mq_admin_password"
}

variable "mq_application_user_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Application username"
  default     = "mq_application_username"
}

variable "mq_application_password_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Application password"
  default     = "mq_application_password"
}



variable "kms_ssm_key_arn" {
  type        = string
  description = "ARN of the AWS KMS key used for SSM encryption"
  default     = "alias/aws/ssm"
}

variable "encryption_enabled" {
  type        = bool
  description = "Flag to enable/disable Amazon MQ encryption at rest"
  default     = true
}

variable "kms_mq_key_arn" {
  type        = string
  description = "ARN of the AWS KMS key used for Amazon MQ encryption"
  default     = null
}

variable "use_aws_owned_key" {
  type        = bool
  description = "Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) for Amazon MQ encryption that is not in your account"
  default     = true
}

variable "allowed_ingress_ports" {
  type        = list(number)
  description = <<-EOT
    List of TCP ports to allow access to in the created security group.
    Default is to allow access to all ports. Set `create_security_group` to `false` to disable.
    Note: List of ports must be known at "plan" time.
    EOT
  default     = []
}

variable "configuration_data" {
  type        = string
  description = "data value for configuration"
  default     = null
}
