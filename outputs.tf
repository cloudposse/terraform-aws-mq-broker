output "broker_id" {
  value = "${join("", aws_mq_broker.default.*.id)}"
}

output "broker_arn" {
  value = "${join("", aws_mq_broker.default.*.arn)}"
}

output "primary_console_url" {
  value = "${join("", aws_mq_broker.default.*.instances.0.console_url)}"
}

output "primary_ssl_endpoint" {
  value = "${join("",aws_mq_broker.default.*.instances.0.endpoints.0i)}"
}

output "primary_ampq_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.0.endpoints.1)}"
}

output "primary_stomp_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.0.endpoints.2)}"
}

output "primary_mqtt_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.0.endpoints.3)}"
}

output "primary_wss_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.0.endpoints.4)}"
}

output "primary_ip_address" {
  value = "${join("", aws_mq_broker.default.*.instances.0.ip_address)}"
}

output "secondary_console_url" {
  value = "${join("", aws_mq_broker.default.*.instances.1.console_url)}"
}

output "secondary_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.1.endpoints.0)}"
}

output "secondary_ampq_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.1.endpoints.1)}"
}

output "secondary_stomp_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.1.endpoints.2)}"
}

output "secondary_mqtt_ssl_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.1.endpoints.3)}"
}

output "secondary_wss_endpoint" {
  value = "${join("", aws_mq_broker.default.*.instances.1.endpoints.4)}"
}

output "secondary_ip_address" {
  value = "${join("", aws_mq_broker.default.*.instances.1.ip_address)}"
}
