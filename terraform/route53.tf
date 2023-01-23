data "aws_route53_zone" "main" {
  name = var.dns_domain
}

resource "aws_route53_zone" "lynx" {
  name          = "${var.cluster_name}.${var.dns_domain}"
  force_destroy = true

  tags = {
    "tigera.fr/environment" = var.cluster_name
  }
}

resource "aws_route53_record" "lynx-ns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.cluster_name}.${var.dns_domain}"
  type    = "NS"
  ttl     = "900"
  records = aws_route53_zone.lynx.name_servers
}
