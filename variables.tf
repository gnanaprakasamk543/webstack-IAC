##EC2 Varibales##
variable "global_key_name" {}
variable "global_availability_zones" {}
variable "server_type" {}
variable "private_subnet_group1" {}
variable "private_subnet_group2" {}
variable "public_subnet_group1" {}
variable "public_subnet_group2" {}
variable "hostname_prefix" {}
variable "global_environment" {}
variable "global_product" {}
variable "contact" {}
variable "vpc_contact" {}
variable "instance_tier" {}

##SG Varibales##
variable "vpc_id" {}
variable "vpc_subnet_cidr" {}
variable "phz_domain" {}
variable "parent_zone_id" {}

##IAM variables##
variable "aws_profile" {}
variable "aws_region" {}  
variable "account_id" {}
variable "password_kms_key" {}
