terraform {
  backend "s3" {
    bucket  = "westack-iac-tr-578774312042"
    key     = "terraform/dev/webserver/terraform.tfstate"
    region  = "us-west-2"
    profile = "aws-naveen-acc"
  }
}
