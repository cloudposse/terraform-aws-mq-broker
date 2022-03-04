locals {
  enabled               = module.this.enabled
  mq_admin_user_enabled = var.engine_type == "ActiveMQ"

  mq_admin_user_is_set = var.mq_admin_user != null && var.mq_admin_user != ""
  mq_admin_user        = local.mq_admin_user_is_set ? var.mq_admin_user : join("", random_string.mq_admin_user.*.result)

  mq_admin_password_is_set = var.mq_admin_password != null && var.mq_admin_password != ""
  mq_admin_password        = local.mq_admin_password_is_set ? var.mq_admin_password : join("", random_password.mq_admin_password.*.result)

  mq_application_user_is_set = var.mq_application_user != null && var.mq_application_user != ""
  mq_application_user        = local.mq_application_user_is_set ? var.mq_application_user : join("", random_string.mq_application_user.*.result)

  mq_application_password_is_set = var.mq_application_password != null && var.mq_application_password != ""
  mq_application_password        = local.mq_application_password_is_set ? var.mq_application_password : join("", random_password.mq_application_password.*.result)
  mq_logs                        = { logs = { "general_log_enabled" : var.general_log_enabled, "audit_log_enabled" : var.audit_log_enabled } }

  security_group_enabled = var.publicly_accessible == true ? false : module.this.enabled && var.security_group_enabled
}

resource "random_string" "mq_admin_user" {
  count   = local.enabled && local.mq_admin_user_enabled && ! local.mq_admin_user_is_set ? 1 : 0
  length  = 8
  special = false
  number  = false
}

resource "random_password" "mq_admin_password" {
  count   = local.enabled && local.mq_admin_user_enabled && ! local.mq_admin_password_is_set ? 1 : 0
  length  = 16
  special = false
}

resource "random_string" "mq_application_user" {
  count   = local.enabled && ! local.mq_application_user_is_set ? 1 : 0
  length  = 8
  special = false
  number  = false
}

resource "random_password" "mq_application_password" {
  count   = local.enabled && ! local.mq_application_password_is_set ? 1 : 0
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "mq_master_username" {
  count       = local.enabled && local.mq_admin_user_enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, "mq_admin_username")
  value       = local.mq_admin_user
  description = "MQ Username for the admin user"
  type        = "String"
  overwrite   = var.overwrite_ssm_parameter
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_master_password" {
  count       = local.enabled && local.mq_admin_user_enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, "mq_admin_password")
  value       = local.mq_admin_password
  description = "MQ Password for the admin user"
  type        = "SecureString"
  key_id      = var.kms_ssm_key_arn
  overwrite   = var.overwrite_ssm_parameter
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_application_username" {
  count       = local.enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, "mq_application_username")
  value       = local.mq_application_user
  description = "AMQ username for the application user"
  type        = "String"
  overwrite   = var.overwrite_ssm_parameter
  tags        = module.this.tags
}

resource "aws_ssm_parameter" "mq_application_password" {
  count       = local.enabled ? 1 : 0
  name        = format(var.ssm_parameter_name_format, var.ssm_path, "mq_application_password")
  value       = local.mq_application_password
  description = "AMQ password for the application user"
  type        = "SecureString"
  key_id      = var.kms_ssm_key_arn
  overwrite   = var.overwrite_ssm_parameter
  tags        = module.this.tags
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

  security_groups = compact(
    sort(concat(
      [module.security_group.id],
      var.security_groups
    ))
  )

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
