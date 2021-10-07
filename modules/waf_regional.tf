variable "waf_name" {
  type        = string
  description = "The name of the Lambda function."
  default     = "StandardACL_Regional"
  #  sensitive   = true
  #  validation {
  #    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
  #    error_message = "Please provide a valid value for variable AMI."
  #  }
}

resource "aws_wafv2_web_acl" "waf_regional" {
  name        = var.waf_name
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

output "waf_regional_arn" {
  value     = aws_wafv2_web_acl.waf_regional.arn
  sensitive = false
}
