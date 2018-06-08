resource "aws_route53_zone" "private" {
  name   = "ocp.internal"
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned"
  )}"
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.ocp.internal"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.masters.*.private_ip}"]
}

resource "aws_route53_record" "compute" {
  count   = "${var.compute_node_count}"
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "compute${count.index}.ocp.internal"
  type    = "A"
  ttl     = "60"
  records = ["${element(aws_instance.computes.*.private_ip, count.index)}"]
}
