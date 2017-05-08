# INPUTS

variable "bucket_name" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "us-west-1"
}

# TASK

# Create single s3 bucket for cats:

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cats" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags {
    Name = "${var.env_name}"
  }
}
data "aws_iam_policy_document" "cats_policy" {
  statement {
    actions   = ["s3:*"]
    resources = [
        "${aws_s3_bucket.cats.arn}",
        "${aws_s3_bucket.cats.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }
  }
}
