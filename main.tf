provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}