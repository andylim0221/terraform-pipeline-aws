data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

variable "lambda_delay" {
  type        = number
  description = "Lambda function delay before each execution."
  default     = 2
}

variable "enabled" {
  type        = string
  description = "System control switch."
  default     = "false"
}
