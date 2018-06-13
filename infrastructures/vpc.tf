resource "aws_vpc" "platform" {
  cidr_block           = "${var.platform_cidr}"
  enable_dns_hostnames = true

  tags = "${map(
    "kubernetes.io/cluster/${local.platform_id}", "owned",
    "Name", "${local.platform_id}"
  )}"
}
