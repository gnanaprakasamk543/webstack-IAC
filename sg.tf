#######################################################################ALB Security group ###################################################
resource "aws_security_group" "alb" {
    name = "alb.sg"
    description = "Allowed inbound and outbound traffic for web ALB"
    vpc_id = "${var.vpc_id}"
    tags = {
	"Name" = "alb.sg"
    }
}

resource "aws_security_group_rule" "allow_https_from_webserver" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "allow_http_from_webserver" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.alb.id}"
}
resource "aws_security_group_rule" "allow_outbound_from_webserver" {
    type = "egress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "allow_https_outbound_from_webserver" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.alb.id}"
}
#####################################################################Ec2 Security group########################################################

resource "aws_security_group" "webserver" {
    name = "sg"
    description = "Allowed inbound and outbound traffic for webservers"
    vpc_id = "${var.vpc_id}"
    tags = {
	"Name" = "webserver.sg"
    }
}

resource "aws_security_group_rule" "allow_http_8080_from_alb" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = "${aws_security_group.alb.id}"
    security_group_id = "${aws_security_group.webstack-IAC_webserver.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "httpforwebserver" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "httpsforwebserver" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.webserver.id}"
}
