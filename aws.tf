# Connect Terraform to AWS.
terraform {
  backend "remote" {
    organization = "fer1035"
    workspaces {
      name = "aws01"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13.0"
}

# Call credentials from remote secrets.
variable "dev_access_key_id" {
  type      = string
  sensitive = true
}
variable "dev_secret_access_key" {
  type      = string
  sensitive = true
}
provider "aws" {
  region     = "us-east-1"
  access_key = var.dev_access_key_id
  secret_key = var.dev_secret_access_key
}

# Declare intrinsic variables.
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
