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
