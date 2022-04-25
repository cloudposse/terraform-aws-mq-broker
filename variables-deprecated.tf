variable "security_group_enabled" {
  type        = bool
  description = <<-EOT
  DEPRECATED: Use `create_security_group` instead
  Whether to create Security Group.
  EOT
  default     = true
}

variable "security_group_use_name_prefix" {
  type        = bool
  default     = false
  description = <<-EOT
  DEPRECATED: Use `security_group_name` and `security_group_create_before_destroy = true` instead.
  Whether to create a default Security Group with unique name beginning with the normalized prefix.
  EOT
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
  DEPRECATED: Use `allowed_security_group_ids` instead.
  A list of Security Group IDs to associate with MQ Broker.
  EOT
}
