resource "aws_route53_zone" "dev" {
  name = "${var.phz_domain}"
  tags = {
    Environment = "dev"
  }
}
resource "aws_route53_record" "dev" {
  zone_id  = "${var.parent_zone_id}"
  name     = "${var.phz_domain}"
  type     = "NS"
  ttl      = "30"
  records = [
    "${aws_route53_zone.vpc_public_zone.name_servers.1}",
    "${aws_route53_zone.vpc_public_zone.name_servers.2}",
      ]
}
