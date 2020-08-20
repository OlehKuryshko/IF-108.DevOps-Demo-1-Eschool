#------------aws dns
data "aws_route53_zone" "selected" {
  name = "${var.dns_zone_name}"
}
resource "aws_route53_record" "my_dns_backend" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "lb-backend.${data.aws_route53_zone.selected.name}"
  type = "A"
  ttl     = "300"
  records = ["${google_compute_global_forwarding_rule.global_forwarding_rule_be.ip_address}"]
  depends_on = [google_compute_global_forwarding_rule.global_forwarding_rule_be]
}