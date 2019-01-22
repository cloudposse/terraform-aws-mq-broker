variable "apply_immediately" {
  type        = "string"
  default     = "false"
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = "string"
  default     = "false"
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
}

variable "deployment_mode" {
  type        = "string"
  default     = "ACTIVE_STANDBY_MULTI_AZ"
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE and ACTIVE_STANDBY_MULTI_AZ"
}

variable "engine_type" {
  type        = "string"
  default     = "ActiveMQ"
  description = "The type of broker engine. Currently, Amazon MQ supports only ActiveMQ"
}

variable "engine_version" {
  type        = "string"
  default     = "5.15.0"
  description = "The version of the broker engine. Currently, Amazon MQ supports only 5.15.0 or 5.15.6."
}

variable "host_instance_type" {
  type        = "string"
  default     = "mq.t2.micro"
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
}

variable "publicly_accessible" {
  type        = "string"
  default     = "false"
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets."
}

variable "general_log" {
  type        = "string"
  default     = "true"
  description = "Enables general logging via CloudWatch"
}

variable "audit_log" {
  type        = "string"
  default     = "true"
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged"
}

variable "maintenance_day_of_week" {
  type        = "string"
  default     = "SUNDAY"
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
}

variable "maintenance_time_of_day" {
  type        = "string"
  default     = "03:00"
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
}

variable "maintenance_time_zone" {
  type        = "string"
  default     = "UTC"
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
}

variable "mq_admin_user" {
  type        = "string"
  default     = ""
  description = "Admin username"
}

variable "mq_admin_password" {
  type        = "string"
  default     = ""
  description = "Admin password"
}

variable "mq_application_user" {
  type        = "string"
  default     = ""
  description = "Application username"
}

variable "mq_application_password" {
  type        = "string"
  default     = ""
  description = "Application password"
}

variable "security_groups" {
  type        = "list"
  description = "List of security groups to be allowed to connect to the ActiveMQ instance"
  default     = []
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
  description = "KMS key ID used to encrypt SSM parameters"
}
