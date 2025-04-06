terraform {
  required_version = ">= 1.3.0"  # Added to satisfy terraform_required_version rule
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"        # Added to satisfy terraform_required_providers rule
    }
  }

  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key    = "agusjuli-s3-tf-ci.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = split("/", data.aws_caller_identity.current.arn)[1]  # Removed deprecated interpolation
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"  # This is acceptable string concatenation
}