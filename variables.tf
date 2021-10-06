variable "api_name" {
  type        = string
  description = "The name of the REST API in API Gateway."
  default     = "myapi"
  #  sensitive   = true
  #  validation {
  #    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
  #    error_message = "Please provide a valid value for variable AMI."
  #  }
}

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

variable "lambda_name" {
  type        = string
  description = "The name of the Lambda function."
  default     = "tf_lambda"
  #  sensitive   = true
  #  validation {
  #    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
  #    error_message = "Please provide a valid value for variable AMI."
  #  }
}
