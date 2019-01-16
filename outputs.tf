output "broker_id" {
  value = "${join("", aws_mq_broker.default.*.id)}"
}

output "broker_arn" {
  value = "${join("", aws_mq_broker.default.*.arn)}"
}

output "primary_console_url" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.console_url, list("")), 0)}"
}

output "primary_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.endpoints.0, list("")), 0)}"
}

output "primary_ampq_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.endpoints.1, list("")), 0)}"
}

output "primary_stomp_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.endpoints.2, list("")), 0)}"
}

output "primary_mqtt_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.endpoints.3, list("")), 0)}"
}

output "primary_wss_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.endpoints.4, list("")), 0)}"
}

output "primary_ip_address" {
  value = "${element(concat(aws_mq_broker.default.*.instances.0.ip_address, list("")), 0)}"
}

output "secondary_console_url" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.console_url, list("")), 0)}"
}

output "secondary_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.endpoints.0, list("")), 0)}"
}

output "secondary_ampq_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.endpoints.1, list("")), 0)}"
}

output "secondary_stomp_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.endpoints.2, list("")), 0)}"
}

output "secondary_mqtt_ssl_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.endpoints.3, list("")), 0)}"
}

output "secondary_wss_endpoint" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.endpoints.4, list("")), 0)}"
}

output "secondary_ip_address" {
  value = "${element(concat(aws_mq_broker.default.*.instances.1.ip_address, list("")), 0)}"
}

output "admin_username" {
  value = "${local.mq_admin_user}"
}

output "application_username" {
  value = "${local.mq_application_user}"
}
