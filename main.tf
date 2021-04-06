provider "aws" {
  profile             = "${var.aws_profile}"
  region              = "${var.aws_region}"
  allowed_account_ids = ["${var.account_id}"]
  version = "~> 2.16"
}
provider "template" {
  version = "~> 1.0"
}
module "vpc" {
  source = "https://github.com/rgnaveen/terraform-vpc.git"

  vpc_contact                 = "${var.vpc_contact}"
  cidr_blocks                 = "${var.cidr_blocks}"
  vpc_subnet                  = "${var.vpc_subnet}"
  global_aws_central_profile  = "${var.aws_central_profile}"
  availability_zones          = "${var.az1},${var.az2}"
  public_subnets              = "${var.public_subnet_az1},${var.public_subnet_az2}"
  private_subnets             = "${var.private_subnet_az1},${var.private_subnet_az2}"
  environment                 = "${var.environment}"
  product                     = "${var.product}"
  vpc_propagating_vgws        = "${module.vpc.vgw_id}"
  domain_name_servers         = "${var.domain_name_servers}"
}
