variable "apply_immediately" {
  type        = "string"
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = "false"
}

variable "enabled" {
  type        = "string"
  default     = "true"
  description = "Set to false to prevent the module from creating any resources"
}

variable "auto_minor_version_upgrade" {
  type        = "string"
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
  default     = "false"
}

variable "broker_name" {
  type        = "string"
  description = "The name of the broker"
  default     = "mq"
}

variable "deployment_mode" {
  type        = "string"
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
  default     = "ACTIVE_STANDBY_MULTI_AZ"
}

variable "engine_type" {
  type        = "string"
  description = "The type of broker engine. Currently, Amazon MQ supports only ActiveMQ"
  default     = "ActiveMQ"
}

variable "engine_version" {
  type        = "string"
  description = "The version of the broker engine. Currently, Amazon MQ supports only 5.15.0 or 5.15.6."
  default     = "5.15.0"
}

variable "configuration_name" {
  type        = "string"
  description = "The name of the MQ configuration"
  default     = "mq"
}

variable "host_instance_type" {
  type        = "string"
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
  default     = "mq.t2.micro"
}

variable "publicly_accessible" {
  type        = "string"
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets."
  default     = "false"
}

variable "general_log" {
  type        = "string"
  description = "Enables general logging via CloudWatch"
  default     = "true"
}

variable "audit_log" {
  type        = "string"
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged"
  default     = "true"
}

variable "maintenance_day_of_week" {
  type        = "string"
  description = "The day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
  default     = "SUNDAY"
}

variable "maintenance_time_of_day" {
  type        = "string"
  description = "The time, in 24-hour format. e.g. 02:00"
  default     = "03:00"
}

variable "maintenance_time_zone" {
  type        = "string"
  description = "The time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
  default     = "UTC"
}

variable "config_template_path" {
  type        = "string"
  description = "Path to ActiveMQ XML config"
  default     = ""
}

# https://www.terraform.io/docs/providers/aws/r/mq_broker.html#user
variable "users" {
  type        = "list"
  description = "List of maps of users"
  default     = [{
    "username"       = "admin"
    "password"       = "defaultpassword"
    "groups"         = ["admin"]
    "console_access" = true
  }]
}

variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups to be allowed to connect to the ActiveMQ instance"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of VPC subnet IDs"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Name of the application"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "chamber_parameter_name" {
  type        = "string"
  default     = "/%s/%s"
  description = "Format to store parameters in SSM, for consumption with chamber"
}

variable "chamber_service" {
  type        = "string"
  default     = ""
  description = "SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default."
}

variable "overwrite_ssm_parameter" {
  type        = "string"
  default     = "true"
  description = "Whether to overwrite an existing SSM parameter"
}

variable "kms_key_id" {
  type        = "string"
  default     = ""
  description = "KMS key id used to encrypt SSM parameters"
}
