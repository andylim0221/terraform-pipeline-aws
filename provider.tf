variable "dev_access_key_id" {
  type = string
  sensitive = true
}

variable "dev_secret_access_key" {
  type = string
  sensitive = true
}

provider "aws" {
  region = "us-east-1"
  access_key = var.dev_access_key_id
  secret_key = var.dev_secret_access_key
}
