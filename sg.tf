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
  for_each = module.this.enabled && var.use_existing_security_groups == false ? {
    for port in local.mq_security_ports : "${port.security_group_id}.${port.port}" => port
  } : {}

  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = each.value.security_group_id
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  for_each = module.this.enabled && var.use_existing_security_groups == false ? {
    for port in local.mq_cidr_ports : "${port.cidr}.${port.port}" => port
  } : {}

  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = [each.value.cidr]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}
