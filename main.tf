locals {
  enabled = module.this.enabled

  mq_admin_user_enabled = local.enabled && var.engine_type == "ActiveMQ"

  mq_admin_user_needed = local.mq_admin_user_enabled && length(var.mq_admin_user) == 0
  mq_admin_user        = local.mq_admin_user_needed ? random_pet.mq_admin_user[0].id : try(var.mq_admin_user[0], "")

  mq_admin_password_needed = local.mq_admin_user_enabled && length(var.mq_admin_password) == 0
  mq_admin_password        = local.mq_admin_password_needed ? random_password.mq_admin_password[0].result : try(var.mq_admin_password[0], "")

  mq_application_user_needed = local.enabled && length(var.mq_application_user) == 0
  mq_application_user        = local.mq_application_user_needed ? random_pet.mq_application_user[0].id : try(var.mq_application_user[0], "")

  mq_application_password_needed = local.enabled && length(var.mq_application_password) == 0
  mq_application_password        = local.mq_application_password_needed ? random_password.mq_application_password[0].result : try(var.mq_application_password[0], "")

  mq_logs = { logs = { "general_log_enabled" : var.general_log_enabled, "audit_log_enabled" : var.audit_log_enabled } }

  broker_security_groups = try(sort(compact(concat([module.security_group.id], local.additional_security_group_ids))), [])
}

resource "random_pet" "mq_admin_user" {
  count     = local.mq_admin_user_needed ? 1 : 0
  length    = 2
  separator = "-"
}

resource "random_password" "mq_admin_password" {
  count   = local.mq_admin_password_needed ? 1 : 0
  length  = 24
  special = false
}

resource "random_pet" "mq_application_user" {
  count     = local.mq_application_user_needed ? 1 : 0
  length    = 2
  separator = "-"
}

resource "random_password" "mq_application_password" {
  count   = local.mq_application_password_needed ? 1 : 0
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "mq_master_username" {
  count       = local.mq_admin_user_enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, var.mq_admin_user_ssm_parameter_name)
  value       = local.mq_admin_user
  description = "MQ Username for the admin user"
  type        = "String"
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_master_password" {
  count       = local.mq_admin_user_enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, var.mq_admin_password_ssm_parameter_name)
  value       = local.mq_admin_password
  description = "MQ Password for the admin user"
  type        = "SecureString"
  key_id      = var.kms_ssm_key_arn
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_application_username" {
  count       = local.enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, var.mq_application_user_ssm_parameter_name)
  value       = local.mq_application_user
  description = "AMQ username for the application user"
  type        = "String"
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_application_password" {
  count       = local.enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, var.mq_application_password_ssm_parameter_name)
  value       = local.mq_application_password
  description = "AMQ password for the application user"
  type        = "SecureString"
  key_id      = var.kms_ssm_key_arn
  tags        = module.this.tags
}

locals {
  configuration_data_create = var.configuration_data == null ? [] : [1]
}

resource "aws_mq_configuration" "default" {
  count          = local.enabled ? length(local.configuration_data_create) : 0
  description    = "Rabbitmq Configuration for ${module.this.id}"
  name           = "${module.this.id}_default_config"
  engine_type    = var.engine_type
  engine_version = var.engine_version
  data           = var.configuration_data
}

resource "aws_mq_broker" "default" {
  count                      = local.enabled ? 1 : 0
  broker_name                = module.this.id
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  publicly_accessible        = var.publicly_accessible
  subnet_ids                 = var.subnet_ids
  tags                       = module.this.tags

  security_groups = local.broker_security_groups

  dynamic "configuration" {
    for_each = local.configuration_data_create
    content {
      id       = aws_mq_configuration.default[0].id
      revision = aws_mq_configuration.default[0].latest_revision
    }
  }

  dynamic "encryption_options" {
    for_each = var.encryption_enabled ? ["true"] : []
    content {
      kms_key_id        = var.kms_mq_key_arn
      use_aws_owned_key = var.use_aws_owned_key
    }
  }

  # NOTE: Omit logs block if both general and audit logs disabled:
  # https://github.com/hashicorp/terraform-provider-aws/issues/18067
  dynamic "logs" {
    for_each = {
      for logs, type in local.mq_logs : logs => type
      if type.general_log_enabled || type.audit_log_enabled
    }
    content {
      general = logs.value["general_log_enabled"]
      audit   = logs.value["audit_log_enabled"]
    }
  }

  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }

  dynamic "user" {
    for_each = local.mq_admin_user_enabled ? ["true"] : []
    content {
      username       = local.mq_admin_user
      password       = local.mq_admin_password
      groups         = ["admin"]
      console_access = true
    }
  }

  user {
    username = local.mq_application_user
    password = local.mq_application_password
  }
}
