variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = false
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
}

variable "deployment_mode" {
  type        = string
  default     = "ACTIVE_STANDBY_MULTI_AZ"
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
}

variable "engine_type" {
  type        = string
  default     = "ActiveMQ"
  description = "The type of broker engine. Currently, Amazon MQ supports only ActiveMQ"
}

variable "engine_version" {
  type        = string
  default     = "5.15.14"
  description = "The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
}

variable "host_instance_type" {
  type        = string
  default     = "mq.t2.micro"
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
}

variable "general_log_enabled" {
  type        = bool
  default     = true
  description = "Enables general logging via CloudWatch"
}

variable "audit_log_enabled" {
  type        = bool
  default     = true
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged"
}

variable "maintenance_day_of_week" {
  type        = string
  default     = "SUNDAY"
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
}

variable "maintenance_time_of_day" {
  type        = string
  default     = "03:00"
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
}

variable "maintenance_time_zone" {
  type        = string
  default     = "UTC"
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
}

variable "mq_admin_user" {
  type        = string
  default     = null
  description = "Admin username"
}

variable "mq_admin_password" {
  type        = string
  default     = null
  description = "Admin password"
}

variable "mq_application_user" {
  type        = string
  default     = null
  description = "Application username"
}

variable "mq_application_password" {
  type        = string
  default     = null
  description = "Application password"
}

variable "allowed_security_groups" {
  type        = list(string)
  description = "List of security groups to be allowed to connect to the broker instance"
  default     = []
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks that are allowed ingress to the broker's Security Group created in the module"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the broker in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "chamber_parameter_name" {
  type        = string
  default     = "/%s/%s"
  description = "Format to store parameters in SSM"
}

variable "chamber_service" {
  type        = string
  default     = ""
  description = "SSM parameter service name"
}

variable "overwrite_ssm_parameter" {
  type        = bool
  default     = true
  description = "Whether to overwrite an existing SSM parameter"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID used to encrypt SSM parameters and for Amazon MQ encryption at rest"
}

variable "use_aws_owned_key" {
  type        = bool
  default     = true
  description = "Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) that is not in your account"
}

variable "use_existing_security_groups" {
  type        = bool
  description = "Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the broker into"
  default     = false
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Group IDs to place the broker into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the broker"
}
