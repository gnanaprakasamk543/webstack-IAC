provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


resource "aws_alb" "webserver_alb" {
  name = "webserver-alb"
  internal = true
  subnets = split(",", var.subnets_private)
  security_groups = ["${aws_security_group.alb.id}"]
  idle_timeout =  "1000"

  tags= {
    Standard = "webserver"
    orchestration = "git@github.com:rgnaveen/westack_IAC.git"
    CostCode = "00000"
    Name = "webserver_ALB"
    Contact = "rg.naveenkumar@hotmail.com"
  }
}

resource "aws_alb_target_group" "webserver_alb_tg" {
  name = "webserver-alb-http-tg"
  port = 80
  protocol = "HTTP"
  deregistration_delay = 30
  vpc_id = "${var.vpc_id}"

  stickiness {
    type = "lb_cookie"
    cookie_duration = "86400"
    enabled = true
  }

  tags= {
    Name = "webserver"
  }

  health_check {
    healthy_threshold = "2"
    unhealthy_threshold = "2"
    timeout = "5"
    interval = "30"
    matcher = "200-299,403"
    port = "80"
    path = "/"
  }
}

resource "aws_alb_target_group" "webserver_alb_https_tg" {
  name = "webserver-alb-https-tg"
  port = 443
  protocol = "HTTPS"
  deregistration_delay = 30
  vpc_id = "${var.vpc_id}"

  stickiness {
    type = "lb_cookie"
    cookie_duration = "86400"
    enabled = true
  }

  tags= {
    Name = "webserver"
  }

  health_check {
    healthy_threshold = "2"
    unhealthy_threshold = "2"
    timeout = "5"
    interval = "30"
    matcher = "200-299,403"
    port = "443"
    path = "/"
  }
}



resource "aws_alb_listener" "webserver_alb_listener" {
  load_balancer_arn = "${aws_alb.webserver_alb.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${data.aws_acm_certificate.domain_cert.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.webserver_alb_https_tg.arn}"
    type = "forward"
  }
}
