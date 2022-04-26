# security-group-variables Version: 2
#
# Copy this file from https://github.com/cloudposse/terraform-aws-security-group/blob/master/exports/security-group-variables.tf
# and EDIT IT TO SUIT YOUR PROJECT. Update the version number above if you update this file from a later version.
# Unlike null-label context.tf, this file cannot be automatically updated
# because of the tight integration with the module using it.
##
# Delete this top comment block, except for the first line (version number),
# REMOVE COMMENTS below that are intended for the initial implementor and not maintainers or end users.
#
# This file provides the standard inputs that all Cloud Posse Open Source
# Terraform module that create AWS Security Groups should implement.
# This file does NOT provide implementation of the inputs, as that
# of course varies with each module.
#
# This file declares some standard outputs modules should create,
# but the declarations should be moved to `outputs.tf` and of course
# may need to be modified based on the module's use of security-group.
#


variable "create_security_group" {
  type        = bool
  default     = true
  description = "Set `true` to create and configure a new security group. If false, `associated_security_group_ids` must be provided."
}

variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access.
    EOT
}

##
## allowed_* inputs are optional, because the same thing can be accomplished by
## providing `additional_security_group_rules`. However, if the rules this
## module creates are non-trivial (for example, opening ports based on
## feature settings, see https://github.com/cloudposse/terraform-aws-msk-apache-kafka-cluster/blob/3fe23c402cc420799ae721186812482335f78d24/main.tf#L14-L53 )
## then it makes sense to include these.
## Reasons not to include some or all of these inputs include
## - too hard to implement
## - does not make sense (particularly the IPv6 inputs if the underlying resource does not yet support IPv6)
## - likely to confuse users
## - likely to invite count/for_each issues
variable "allowed_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv4 CIDRs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv6 CIDRs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_ipv6_prefix_list_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv6 Prefix Lists IDs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}
## End of optional allowed_* ###########

variable "security_group_name" {
  type        = list(string)
  default     = []
  description = <<-EOT
    The name to assign to the created security group. Must be unique within the VPC.
    If not provided, will be derived from the `null-label.context` passed in.
    If `create_before_destroy` is true, will be used as a name prefix.
    EOT
}

variable "security_group_description" {
  type        = string
  default     = "Managed by Terraform"
  description = <<-EOT
    The description to assign to the created Security Group.
    Warning: Changing the description causes the security group to be replaced.
    EOT
}

###############################
#
# Decide on a case-by-case basis what the default should be.
# In general, if the resource supports changing security groups without deleting
# the resource or anything it depends on, then default it to `true` and
# note in the release notes and migration documents the option to
# set it to `false` to preserve the existing security group.
# If the resource has to be deleted to change its security group,
# then set the default to `false` and highlight the option to change
# it to `true` in the release notes and migration documents.
#
################################
variable "security_group_create_before_destroy" {
  type = bool
  #
  # Pick `true` or `false` and the associated description.
  # Use `true` unless replacing the security group causes the underlying resource
  # (e.g. the EC2 instance, not just the security group) to be destroyed and recreated.
  #
  # Replace "the resource" in the description with the name of the resource, e.g. "EC2 instance".
  #

  #  default     = true
  #  description = <<-EOT
  #    Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.
  #    We only recommend setting this `false` if you are upgrading this module and need to keep
  #    the existing security group from being replaced.
  #    Note that changing this value will always cause the security group to be replaced.
  #    EOT

  #  default     = false
  #  description = <<-EOT
  #    Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.
  #    We recommend setting this `true` on new security groups, but default it to `false` because `true`
  #    will cause existing security groups to be replaced, possibly requiring the resource to be deleted and recreated.
  #    Note that changing this value will always cause the security group to be replaced.
  #    EOT

}

variable "security_group_create_timeout" {
  type        = string
  default     = "10m"
  description = "How long to wait for the security group to be created."
}

variable "security_group_delete_timeout" {
  type        = string
  default     = "15m"
  description = <<-EOT
    How long to retry on `DependencyViolation` errors during security group deletion from
    lingering ENIs left by certain AWS services such as Elastic Load Balancing.
    EOT
}

variable "allow_all_egress" {
  type        = bool
  default     = true
  description = <<-EOT
    If `true`, the created security group will allow egress on all ports and protocols to all IP addresses.
    If this is false and no egress rules are otherwise specified, then no egress will be allowed.
    EOT
}

variable "additional_security_group_rules" {
  type        = list(any)
  default     = []
  description = <<-EOT
    A list of Security Group rule objects to add to the created security group, in addition to the ones
    this module normally creates. (To suppress the module's rules, set `create_security_group` to false
    and supply your own security group(s) via `associated_security_group_ids`.)
    The keys and values of the objects are fully compatible with the `aws_security_group_rule` resource, except
    for `security_group_id` which will be ignored, and the optional "key" which, if provided, must be unique and known at "plan" time.
    For more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
    and https://github.com/cloudposse/terraform-aws-security-group.
    EOT
}

#### We do not expose an `additional_security_group_rule_matrix` input for a few reasons:
# - It is a convenience and ultimately provides no rules that cannot be provided via `additional_security_group_rules`
# - It is complicated and can, in some situations, create problems for Terraform `for_each`
# - It is difficult to document and easy to make mistakes using it


## vpc_id is required, but if needed for reasons other than the security group,
## it should be defined in the main `variables.tf` file, not here.
# variable "vpc_id" {
#   type        = string
#   description = "The ID of the VPC where the Security Group will be created."
# }


#
#
#### The variables below (but not the outputs) can be omitted if not needed, and may need their descriptions modified
#
#

#############################################################################################
## Special note about inline_rules_enabled and revoke_rules_on_delete
##
## The security-group inputs inline_rules_enabled and revoke_rules_on_delete should not
## be exposed in other modules unless there is a strong reason for them to be used.
## We discourage the use of inline_rules_enabled and we rarely need or want
## revoke_rules_on_delete, so we do not want to clutter our interface with those inputs.
##
## If someone wants to enable either of those options, they have the option
## of creating a security group configured as they like
## and passing it in as the target security group.
#############################################################################################

variable "inline_rules_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
    NOT RECOMMENDED. Create rules "inline" instead of as separate `aws_security_group_rule` resources.
    See [#20046](https://github.com/hashicorp/terraform-provider-aws/issues/20046) for one of several issues with inline rules.
    See [this post](https://github.com/hashicorp/terraform-provider-aws/pull/9032#issuecomment-639545250) for details on the difference between inline rules and rule resources.
    EOT
}

variable "revoke_security_group_rules_on_delete" {
  type        = bool
  default     = false
  description = <<-EOT
    Instruct Terraform to revoke all of the Security Group's attached ingress and egress rules before deleting
    the security group itself. This is normally not needed.
    EOT
}


##
##
################# Outputs
##
## Move to `outputs.tf`
##
##

output "security_group_id" {
  value       = join("", module.security_group.*.id)
  description = "The ID of the created security group"
}

output "security_group_arn" {
  value       = join("", module.security_group.*.arn)
  description = "The ARN of the created security group"
}

output "security_group_name" {
  value       = join("", module.security_group.*.name)
  description = "The name of the created security group"
}
