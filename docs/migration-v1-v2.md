# Migration From v1 to v2

NOTE: v1.0.0 is functionally equivalent to v0.14.0. 
This is not a migration guide from the pre-release versions 0.15.0 and 0.15.1
and we do not plan to provide one.

Version 2.0.0 of this module introduces changes that will cause a 
direct update to fail to apply, and without additional steps will also cause 
the security group, MQ users, and passwords created by this module to be 
destroyed and replaced with new ones.

### Simple migration

The simplest migration path is to update to the new version, allowing
the new defaults to take effect, and then moving the existing
security group to the new "resource address". (More difficult but
less disruptive migration is detailed below under )

- Modify your module reference to refer to the new version
- Run `terraform plan`
- Note the Terraform addresses of the security group Terraform will destroy and the one it will create
- Use `terraform state mv` to move the former to the latter, something like
```
terraform state mv 'module.mq_broker.aws_security_group.default[0]' 'module.mq_broker.module.security_group.aws_security_group.cbd[0]'
```
- Run `terraform plan` again and verify that no security groups will be destroyed, but rather the `cbd[0]` group will be replaced
- Finish by applying the plan

In this migration, the security group, MQ users, and MQ passwords created by this module will be destroyed and replaced with new ones.
We recommend allowing this and treating it as part of your password rotation practice, however
be warned that it will cause an outage while you update clients to use the new username and password.

Using `mv` to move the security group resource and enabling "create before destroy" (the new default) are required, 
otherwise Terraform cannot delete the existing security group because it is still in use. The
Terraform 1.1.0 `moved` feature cannot be used because the resource is being 
moved to a non-local module.

Version `2.0.0` of this module introduces changes that, without taking additional precautions, 
will cause the security group created by this module to be replaced with a new one. 
This is because of the newer version's reliance on the [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group)
module for managing the module's security group. This changes the Terraform resource address.

If this is acceptable (which it could be if no other resource uses or references it),
then the easiest thing to do is just to allow Terraform to do it.
To preserve the existing security group, after bumping the module version to the newer version, 
run `terraform plan` and make note of the proposed changes.

### Migration With Minimal Disruption

Avoiding a service outage when upgrading to version 2 of this module is difficult
and may not be worth the effort. We recommend performing the simple migration
described above, allowing the broker's credentials to be rotated. In order
to avoid rotating the credentials, you must supply them as inputs to the 
upgraded module (the generated user names have been made user-friendly and the
generated passwords have been lengthened for security), which is a security breach
if your configuration is available for others to read, which is normally the case.
If you rotate the credentials, that service interruption will cover the
minimal network connectivity interruption that comes from performing the
simple migration.

If you want to attempt a zero downtime migration, follow these steps.

To start:
- Set `security_group_create_before_destroy = false` to prevent using `name_prefix` on the SG resource
- Modify your module reference to refer to the new version of `cloudposse/mq-broker/aws`
- Run `terraform plan`

Note the Terraform resource addresses of the Security Group that Terraform plans to destroy,
and the resource address of the SG which Terraform plans to create. Use
`terraform state mv` to move the old address to the new address. 

Use the output of `terraform plan` to find the correct addresses to 
use in the following command:
```bash
# required - move the security group resource
terraform state mv \
  'module.mq_broker.aws_security_group.default[0]' \
  'module.mq_broker.module.security_group.aws_security_group.default[0]'
```

#### Move/update/import the Security Group Rules

You have the option to move the security group rules, too. 
If you do not move them, they will be deleted
and recreated, causing a brief outage. If you do move them, then because
of [a bug in the Terraform AWS provider](https://github.com/hashicorp/terraform-provider-aws/issues/25173)
you will need to manually add a rule to the security group and then import it. 

Get the addresses of the source and destination resources, and the ID of the 
security group, from the `terraform plan` output of the previous step.

Move the ingress rule:

```bash
terraform state mv \
  'module.mq_broker.aws_security_group_rule.ingress_security_groups[0]'\
  'module.mq_broker.module.security_group.aws_security_group_rule.keyed["_allowed_ingress#_all_ingress#sg#0"]'
```

Remove the old egress rule (which Terraform plans to destroy) from the Terraform state:

```bash
terraform state rm 'module.mq_broker.aws_security_group_rule.egress[0]'
```

Add the IPv6 egress rule to the security group (replace `sg-1234567890abcdef0`)
with the ID of your security group:

```bash
SECURITY_GROUP_ID=sg-1234567890abcdef0
aws ec2 authorize-security-group-egress \
    --group-id $SECURITY_GROUP_ID \
    --ip-permissions IpProtocol=-1,FromPort=0,ToPort=0,Ipv6Ranges='[{CidrIpv6=::/0}]'
```

Import the newly created rule into Terraform state at the address where
Terraform planned to create it (again, replace `sg-1234567890abcdef0`
with your actual security group ID):

```bash
SECURITY_GROUP_ID=sg-1234567890abcdef0
tf import 'module.mq_broker.module.security_group.aws_security_group_rule.keyed["_allow_all_egress_"]' \
   ${SECURITY_GROUP_ID}_egress_all_0_65536_0.0.0.0/0_::/0
```

This will result in a plan that will only update security group rules' descriptions, but not the security group itself.
However, at this point, the plan will still be replacing all the user names and passwords. 
Your only option for preserving the old usernames and passwords is to 
pass the old values as inputs.

Please run a `terraform plan` to make sure there aren't other unexpected breaking changes.

## Changes to inputs

In addition to new inputs with new functionality (not covered in this document),
you may want or need to update your code in order to adapt to changed or deprecated inputs.

* `allowed_security_groups` is deprecated. Use `allowed_security_group_ids` instead.
* `existing_security_groups` is deprecated. Use `associated_security_group_ids` instead
* `use_existing_security_groups` is deprecated. Use `create_security_group` instead.
* The MQ User configuration variables
  - `mq_admin_user`
  - `mq_admin_password`
  - `mq_application_user`
  - `mq_application_password`

  have changed from `string` to `list(string)`. Furthermore, the length of the
  generated passwords has changed, and user names are now human-friendly "pet"
  names instead of random strings. If you were setting them before, you need
  to change them lists. If you were not setting them before but want to preserve
  the old values, you need to set to the old values explicitly.

## References

* https://github.com/cloudposse/terraform-aws-security-group/releases/tag/0.4.0
* https://github.com/hashicorp/terraform-provider-aws/issues/25173
