################################################################################
## Common

variable "account_id" {
  type = "string"
  default = "772663561820"
}

# Repeated in backend config
variable "state_bucket" {
  type = "string"
  default = "terraform.charemza.name"
}

terraform {
  backend "s3" {
    # Repeated in variables above, since can't use interpolation here
    bucket = "terraform.charemza.name"
    key    = "infrastructure.tfstate"
    region = "eu-west-1"
    profile = "infrastructure"
    lock_table = "infrastructure"
  }
}

provider "aws" {
  region = "eu-west-1"
  profile = "infrastructure"
}

################################################################################
## hhttpserver

resource "aws_iam_user" "hhttpserver_infrastructure" {
  name = "hhttpserver_infrastructure"
}

resource "aws_iam_access_key" "hhttpserver_infrastructure_key" {
  user = "${aws_iam_user.hhttpserver_infrastructure.name}"
  pgp_key = "${file("public.key")}"
}

resource "aws_iam_user_policy_attachment" "hhttpserver_infrastructure" {
  user = "${aws_iam_user.hhttpserver_infrastructure.name}"
  policy_arn = "${aws_iam_policy.hhttpserver_infrastructure.arn}"
}

resource "aws_iam_policy" "hhttpserver_infrastructure" {
  name = "hhttpserver_infrastructure"
  policy = "${data.aws_iam_policy_document.hhttpserver_infrastructure.json}"
}

resource "aws_dynamodb_table" "hhttpserver_infrastructure" {
  name = "hhttpserver_infrastructure"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}

data "aws_iam_policy_document" "hhttpserver_infrastructure" {
  statement {
    effect = "Allow"
    actions = [
      "*",
    ]
    resources = [
      "arn:aws:s3:::${var.state_bucket}/hhttpserver.tfstate"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem"
    ]
    resources = [
      "arn:aws:dynamodb:eu-west-1:${var.account_id}:table/hhttpserver_infrastructure"
    ]
  }
}

output "hhttpserver_infrastructure_aws_access_key_id" {
  value = "${aws_iam_access_key.hhttpserver_infrastructure_key.id}"
}

output "hhttpserver_infrastructure_aws_secret_access_key" {
  value = "${aws_iam_access_key.hhttpserver_infrastructure_key.encrypted_secret}"
}
