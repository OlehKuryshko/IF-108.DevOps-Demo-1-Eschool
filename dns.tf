#------------aws
data "aws_route53_zone" "selected" {
  name = "${var.dns_zone_name}"
}

resource "aws_route53_record" "my_dns" {
  count = "${length(var.name_count)}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "lb-${element(var.name_lb, count.index)}.${data.aws_route53_zone.selected.name}"
  type = "A"
  ttl     = "300"
  records = ["${element(google_compute_instance.lb[*].network_interface.0.access_config.0.nat_ip, count.index)}"]
}
