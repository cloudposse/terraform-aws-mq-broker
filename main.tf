locals {
  kms_key_id              = length(var.kms_key_id) > 0 ? var.kms_key_id : format("alias/%s-%s-chamber", var.namespace, var.stage)
  key_id                  = join("", data.aws_kms_key.chamber_kms_key.*.id)
  chamber_service         = var.chamber_service == "" ? basename(pathexpand(path.module)) : var.chamber_service
  mq_admin_user           = length(var.mq_admin_user) > 0 ? var.mq_admin_user : random_string.mq_admin_user.result
  mq_admin_password       = length(var.mq_admin_password) > 0 ? var.mq_admin_password : random_password.mq_admin_password.result
  mq_application_user     = length(var.mq_application_user) > 0 ? var.mq_application_user : random_string.mq_application_user.result
  mq_application_password = length(var.mq_application_password) > 0 ? var.mq_application_password : random_password.mq_application_password.result
}

data "aws_kms_key" "chamber_kms_key" {
  key_id = local.kms_key_id
}

resource "random_string" "mq_admin_user" {
  length  = 8
  special = false
  number  = false
}

resource "random_password" "mq_admin_password" {
  length  = 16
  special = false
}

resource "random_string" "mq_application_user" {
  length  = 8
  special = false
  number  = false
}

resource "random_password" "mq_application_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "mq_master_username" {
  name        = format(var.chamber_parameter_name, local.chamber_service, "mq_admin_username")
  value       = local.mq_admin_user
  description = "MQ Username for the master user"
  type        = "String"
  overwrite   = var.overwrite_ssm_parameter
}

resource "aws_ssm_parameter" "mq_master_password" {
  name        = format(var.chamber_parameter_name, local.chamber_service, "mq_admin_password")
  value       = local.mq_admin_password
  description = "MQ Password for the master user"
  type        = "SecureString"
  key_id      = local.key_id
  overwrite   = var.overwrite_ssm_parameter
}

resource "aws_ssm_parameter" "mq_application_username" {
  name        = format(var.chamber_parameter_name, local.chamber_service, "mq_application_username")
  value       = local.mq_application_user
  description = "AMQ username for the application user"
  type        = "String"
  overwrite   = var.overwrite_ssm_parameter
}

resource "aws_ssm_parameter" "mq_application_password" {
  name        = format(var.chamber_parameter_name, local.chamber_service, "mq_application_password")
  value       = local.mq_application_password
  description = "AMQ password for the application user"
  type        = "SecureString"
  key_id      = local.key_id
  overwrite   = var.overwrite_ssm_parameter
}

resource "aws_mq_broker" "default" {
  broker_name                = module.this.id
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  publicly_accessible        = var.publicly_accessible
  security_groups            = var.use_existing_security_groups ? var.existing_security_groups : [join("", aws_security_group.default.*.id)]
  subnet_ids                 = var.subnet_ids

  encryption_options {
    kms_key_id        = var.kms_key_id
    use_aws_owned_key = var.use_aws_owned_key
  }

  logs {
    general = var.general_log_enabled
    audit   = var.audit_log_enabled
  }

  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }

  user {
    username       = local.mq_admin_user
    password       = local.mq_admin_password
    groups         = ["admin"]
    console_access = true
  }

  user {
    username = local.mq_application_user
    password = local.mq_application_password
  }
}

resource "aws_security_group" "default" {
  count  = module.this.enabled && var.use_existing_security_groups == false ? 1 : 0
  vpc_id = var.vpc_id
  name   = module.this.id
  tags   = module.this.tags
}

resource "aws_security_group_rule" "egress" {
  count             = module.this.enabled && var.use_existing_security_groups == false ? 1 : 0
  description       = "Allow outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = module.this.enabled && var.use_existing_security_groups == false ? length(var.allowed_security_groups) : 0
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = module.this.enabled && var.use_existing_security_groups == false && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = "0"
  to_port           = "0"
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}
