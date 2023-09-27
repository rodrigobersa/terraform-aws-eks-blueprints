module "standalone_security_hub" {
  source  = "aws-ia/security-hub/aws"
  version = "0.0.1"

  enable_default_standards  = false
  control_finding_generator = "STANDARD_CONTROL"
  auto_enable_controls      = true

  product_config = [{
    enable = true
    arn    = "arn:aws:securityhub:${local.region}::product/aws/guardduty"
  }]

  standards_config = {
    aws_foundational_security_best_practices = {
      enable = true
      status = "ENABLED"
    }
    cis_aws_foundations_benchmark_v120 = {
      enable = false
    }
    cis_aws_foundations_benchmark_v140 = {
      enable = true
      status = "ENABLED"
    }
    nist_sp_800_53_rev5 = {
      enable = false
    }
    pci_dss = {
      enable = false
    }
  }

  action_target = [{
    name        = "Send to Amazon SNS"
    identifier  = "SendToSNS"
    description = "This is a custom action to send findings to SNS Topic"
  }]

}

# Security Hub Insights Examples
# Full list of filters https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_insight#filters

resource "aws_securityhub_insight" "this" {
  filters {
    created_at {
      date_range {
        unit  = "DAYS"
        value = 7
      }
    }
    network_source_ipv4 {
      cidr = "10.0.0.0/16"
    }
    criticality {
      gte = "80"
    }
    resource_tags {
      comparison = "EQUALS"
      key        = "Environment"
      value      = "Development"
    }
  }

  group_by_attribute = "AwsAccountId"

  name = "insight"

  depends_on = [module.standalone_security_hub]
}
