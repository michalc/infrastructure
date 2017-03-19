################################################################################
## Common

terraform {
  backend "s3" {
    bucket = "terraform.charemza.name"
    key    = "infrastructure.tfstate"
    region = "eu-west-1"
    profile = "infrastructure"
    lock_table = "infrastructure"
    encrypt = "1"
    kms_key_id = "arn:aws:kms:eu-west-1:772663561820:key/a088d01e-8d92-4766-ad98-ad8aebacdebd"
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

output "hhttpserver_infrastructure_aws_access_key_id" {
  value = "${aws_iam_access_key.hhttpserver_infrastructure_key.id}"
}

output "hhttpserver_infrastructure_aws_secret_access_key" {
  value = "${aws_iam_access_key.hhttpserver_infrastructure_key.encrypted_secret}"
}
