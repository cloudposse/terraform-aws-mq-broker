module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.5.4"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

locals {
  enabled                 = "${var.enabled == "true" ? true : false}"
  kms_key_id              = "${length(var.kms_key_id) > 0 ? var.kms_key_id : format("alias/%s-%s-chamber", var.namespace, var.stage)}"
  key_id                  = "${join("", data.aws_kms_key.chamber_kms_key.*.id)}"
  chamber_service         = "${var.chamber_service == "" ? basename(pathexpand(path.module)) : var.chamber_service}"
  mq_admin_user           = "${length(var.mq_admin_user) > 0 ? var.mq_admin_user : join("", random_string.mq_admin_user.*.result)}"
  mq_admin_password       = "${length(var.mq_admin_password) > 0 ? var.mq_admin_password : join("", random_string.mq_admin_password.*.result)}"
  mq_application_user     = "${length(var.mq_application_user) > 0 ? var.mq_application_user : join("", random_string.mq_application_user.*.result)}"
  mq_application_password = "${length(var.mq_application_password) > 0 ? var.mq_application_password : join("", random_string.mq_application_password.*.result)}"
}

data "aws_kms_key" "chamber_kms_key" {
  count  = "${var.enabled ? 1 : 0}"
  key_id = "${local.kms_key_id}"
}

resource "random_string" "mq_admin_user" {
  count   = "${local.enabled ? 1 : 0}"
  length  = 8
  special = false
  number  = false
}

resource "random_string" "mq_admin_password" {
  count   = "${local.enabled ? 1 : 0}"
  length  = 16
  special = false
}

resource "random_string" "mq_application_user" {
  count   = "${local.enabled ? 1 : 0}"
  length  = 8
  special = false
  number  = false
}

resource "random_string" "mq_application_password" {
  count   = "${local.enabled ? 1 : 0}"
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "mq_master_username" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${format(var.chamber_parameter_name, local.chamber_service, "mq_admin_username")}"
  value       = "${local.mq_admin_user}"
  description = "MQ Username for the master user"
  type        = "String"
  overwrite   = "${var.overwrite_ssm_parameter}"
}

resource "aws_ssm_parameter" "mq_master_password" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${format(var.chamber_parameter_name, local.chamber_service, "mq_admin_password")}"
  value       = "${local.mq_admin_password}"
  description = "MQ Password for the master user"
  type        = "SecureString"
  key_id      = "${local.key_id}"
  overwrite   = "${var.overwrite_ssm_parameter}"
}

resource "aws_ssm_parameter" "mq_application_username" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${format(var.chamber_parameter_name, local.chamber_service, "mq_application_username")}"
  value       = "${local.mq_application_user}"
  description = "AMQ username for the application user"
  type        = "String"
  overwrite   = "${var.overwrite_ssm_parameter}"
}

resource "aws_ssm_parameter" "mq_application_password" {
  count       = "${local.enabled ? 1 : 0}"
  name        = "${format(var.chamber_parameter_name, local.chamber_service, "mq_application_password")}"
  value       = "${local.mq_application_password}"
  description = "AMQ password for the application user"
  type        = "SecureString"
  key_id      = "${local.key_id}"
  overwrite   = "${var.overwrite_ssm_parameter}"
}

resource "aws_mq_broker" "default" {
  count                      = "${local.enabled ? 1 : 0}"
  broker_name                = "${module.label.id}"
  deployment_mode            = "${var.deployment_mode}"
  engine_type                = "${var.engine_type}"
  engine_version             = "${var.engine_version}"
  host_instance_type         = "${var.host_instance_type}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  apply_immediately          = "${var.apply_immediately}"
  publicly_accessible        = "${var.publicly_accessible}"
  security_groups            = ["${join("", aws_security_group.default.*.id)}"]
  subnet_ids                 = ["${var.subnet_ids}"]

  logs {
    general = "${var.general_log}"
    audit   = "${var.audit_log}"
  }

  maintenance_window_start_time {
    day_of_week = "${var.maintenance_day_of_week}"
    time_of_day = "${var.maintenance_time_of_day}"
    time_zone   = "${var.maintenance_time_zone}"
  }

  user = [{
    "username"       = "${local.mq_admin_user}"
    "password"       = "${local.mq_admin_password}"
    "groups"         = ["admin"]
    "console_access" = true
  }]

  user = [{
    "username" = "${local.mq_application_user}"
    "password" = "${local.mq_application_password}"
  }]
}

resource "aws_security_group" "default" {
  count  = "${local.enabled ? 1 : 0}"
  vpc_id = "${var.vpc_id}"
  name   = "${module.label.id}"
  tags   = "${module.label.tags}"
}

resource "aws_security_group_rule" "default" {
  count                    = "${local.enabled && length(var.security_groups) > 0 ? length(var.security_groups) : 0}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "0"
  to_port                  = "0"
  source_security_group_id = "${element(var.security_groups, count.index)}"
  security_group_id        = "${join("", aws_security_group.default.*.id)}"
}
