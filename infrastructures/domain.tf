resource "aws_route53_zone" "private" {
  name   = "ocp.internal"
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${local.platform_id}", "owned"
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

resource "aws_route53_zone" "public" {
  name   = "ocp.example.com"
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${map(
    "kubernetes.io/cluster/${local.platform_id}", "owned"
  )}"
}

resource "aws_route53_record" "master_public" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name    = "master.ocp.example.com"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.masters.*.private_ip}"]
}
