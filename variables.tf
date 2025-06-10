variable "aws_region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "tf-aws-app"
}

variable "account_id" {
  default = data.aws_caller_identity.current.account_id
}

