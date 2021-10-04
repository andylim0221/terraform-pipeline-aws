variable "access_key_id" {
  type = string
  sensitive = true
}

variable "secret_access_key" {
  type = string
  sensitive = true
}

provider "aws" {
  region = "us-east-1"
  access_key = var.access_key_id
  secret_key = var.secret_access_key
}
