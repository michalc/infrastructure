Infrastructure
==============

The purpose of this repository is to create the users/s3 buckets/dynamodb tables that can be used by Terraform to create the infrastructure and hold the state for other projects. This is the only repository that should need anything in AWS created outside of Terraform.

Usage
-----

First time use:

    brew install terraform [on Mac OSX]
    terraform init

To preview changes:

    terraform plan -out plan

To then apply them:

    terraform apply plan

Credentials
-----------

Credentials are encrypted with the private key corresponding to the one in public.key. To decrypt, on a system with the private key, use

    terraform output [name of resource] | base64 --decode | gpg2 --decrypt