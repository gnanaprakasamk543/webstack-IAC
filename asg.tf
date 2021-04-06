resource "aws_autoscaling_group" "webserver_asg" {
  name                      = "webserver.asg"
  max_size                  = "1"
  min_size                  = "1"
  health_check_grace_period = 0
  health_check_type         = ""
  target_group_arns         = ["${aws_alb_target_group.webserver_alb_tg.arn}","${aws_alb_target_group.webserver_alb_https_tg.arn}"]
  desired_capacity          = "1"
  vpc_zone_identifier       = ["subnet-081ee3546bf001492,subnet-075c1ed1f69f2c9ea"]
  launch_configuration      = "${aws_launch_configuration.webserver_launch_configuration.id}"
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "webserver.scaledinstance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Contact"
    value               = "${var.contact}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Product"
    value               = "iacwebstack"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
  tag {
    key                 = "CostCode"
    value               = "00000"
    propagate_at_launch = true
  }
  tag {
    key                 = "CreatedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "cpm_backup"
    value               = "${var.cpm_backup}"
    propagate_at_launch = true
  }

}

resource "aws_launch_configuration" "webserver_launch_configuration" {
  name_prefix   = "webserver"
  image_id      = data.aws_ami.base_ami.id
  instance_type = "t2.medium"
  key_name      = "${var.global_key_name}"

  root_block_device {
    volume_size           = "100"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  security_groups      = ["${aws_security_group.webserver.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.webserver_iam_instance_profile.id}"
  user_data            = "${data.template_file.webserver_user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "webserver_user_data" {
  template = "${file("${path.module}/files/userdata-webserver.tpl")}"

  vars= {
    s3_deployment_bucket = "Need to configure bucketid"
    product              = "iacwebstack"
    environment          = "dev"
    aws_cwl_region       = "Need to configure cloudwatch alert id"
  }
}
