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
  enabled              = "${var.enabled == "true" ? true : false}"
  config_template_path = "${length(var.config_template_path) > 0 ? var.config_template_path : format("%s/templates/config.xml", path.module)}"
}

data "aws_kms_key" "chamber_kms_key" {
  count  = "${var.enabled ? 1 : 0}"
  key_id = "${local.kms_key_id}"
}

resource "aws_mq_configuration" "default" {
  count          = "${local.enabled ? 1 : 0}"
  name           = "${module.label.id}-${var.configuration_name}"
  engine_type    = "${var.engine_type}"
  engine_version = "${var.engine_version}"
  data           = "${data.template_file.default.rendered}"
}

resource "aws_mq_broker" "default" {
  count       = "${local.enabled ? 1 : 0}"
  broker_name = "${module.label.id}-${var.broker_name}"

  configuration {
    id       = "${join("", aws_mq_configuration.default.*.id)}"
    revision = "${join("", aws_mq_configuration.default.*.latest_revision)}"
  }

  deployment_mode            = "${var.deployment_mode}"
  engine_type                = "${var.engine_type}"
  engine_version             = "${var.engine_version}"
  host_instance_type         = "${var.host_instance_type}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  apply_immediately          = "${var.apply_immediately}"
  publicly_accessible        = "${var.publicly_accessible}"
  security_groups            = ["${aws_security_group.default.id}"]
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

  user = "${var.users}"
}

resource "aws_security_group" "default" {
  count  = "${local.enabled ? 1 : 0}"
  vpc_id = "${var.vpc_id}"
  name   = "${module.label.id}-${var.broker_name}"
  tags   = "${module.label.tags}"
}

resource "aws_security_group_rule" "default" {
  count                    = "${local.enabled && length(var.security_groups) > 0 ? length(var.security_groups) : 0}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "0"
  to_port                  = "0"
  source_security_group_id = "${element(var.security_groups, count.index)}"
  security_group_id        = "${aws_security_group.default.id}"
}
