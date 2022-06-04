variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
  DEPRECATED: Use `allowed_security_group_ids` instead.
  A list of Security Group IDs to to be allowed to connect to the broker instance.
  EOT
}


variable "use_existing_security_groups" {
  type        = bool
  description = <<-EOT
    DEPRECATED: Use `create_security_group` instead.
    Historical description: Set to `true` to disable Security Group creation
    EOT
  default     = null
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
    DEPRECATED: Use `associated_security_group_ids` instead.
    List of existing Security Group IDs to place the broker into.
    EOT
}
