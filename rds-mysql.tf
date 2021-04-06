data "aws_ssm_parameter" "mysqlpassword" {
  name = "dbpassword"
}

module "db" {
  source = "git::ssh://git@github.com:rgnaveen/terraform-rds.git"

  vpc_id                         = "${var.vpc_id}"
  rds_instance_basename          = "db"
  rds_instance_class             = "db.t3.medium"
  rds_storage_type               = "gp2"
  rds_allocated_storage          = "20"
  rds_deletion_protection        = "true"
  rds_tag_cpm_backup             = "no-backup"
  rds_engine_type                = "mysql"
  rds_engine_version             = "5.6.40"
  rds_database_name              = "dev"
  rds_license_model              = "general-public-license"
  rds_database_user              = "dbamaster"
  rds_database_password          = "${data.aws_ssm_parameter.mysqlpassword.value}"
  rds_db_parameter_group_family  = "mysql5.6"
  rds_private_subnets            = "${var.subnets_private}"
  rds_multi_az                   = "false"
  rds_db_port                    = "3306"
  rds_db_protocol                = "TCP"
  rds_trusted_sg                 = "${aws_security_group.ucapp_webserver.id}"
  rds_additional_cidr_blocks     = var.additional_cidr_blocks
  rds_kms_key_id                 = module.kmskey.kmskey_arn
  rds_tag_product                = "webstack"
  rds_tag_environment            = "dev"
  rds_tag_cost_code              = "00000"
  rds_tag_orchestration          = "westack_iac_tr.git"
  rds_auto_minor_version_upgrade = "false"
  rds_tag_description            = "webstack"
  rds_tag_contact                = "rg.naveenkumar@hotmail.com"
  rds_apps                       = "apachephp"
  rds_tag_role                   = "devdbrole"
}
