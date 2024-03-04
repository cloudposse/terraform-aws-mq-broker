region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "mq-broker"

apply_immediately = true

auto_minor_version_upgrade = true

deployment_mode = "ACTIVE_STANDBY_MULTI_AZ"

engine_type = "ActiveMQ"

engine_version = "5.17.6"

# https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-instance-types.html

host_instance_type = "mq.t3.micro"

publicly_accessible = false

general_log_enabled = true

audit_log_enabled = true

use_existing_security_groups = false

encryption_enabled = true

use_aws_owned_key = true
