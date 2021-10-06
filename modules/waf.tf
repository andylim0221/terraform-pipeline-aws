resource "aws_wafv2_web_acl" "waf_regional" {

  name        = "StandardACL_Regional"
  description = "Standard WebACL for API Gateway, TerraForm deploy."
  scope       = "REGIONAL"
  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRule"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        # excluded_rule {
        #   name = "GenericRFI_QUERYARGUMENTS"
        # }
        # excluded_rule {
        #   name = "GenericRFI_BODY"
        # }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesCommonRule"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRule"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesKnownBadInputsRule"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputation"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesAmazonIpReputation"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "StandardACL"
    sampled_requests_enabled   = false
  }

}

output "waf_arn" {
  value = aws_wafv2_web_acl.waf_regional.arn
}
