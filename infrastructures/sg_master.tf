resource "aws_security_group" "master_public" {
  name        = "${local.platform_id}-master-public"
  description = "Master public group for ${local.platform_id}"

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${local.platform_id}", "owned",
    "Name", "${local.platform_id}-master-public"
  )}"

  vpc_id = "${aws_vpc.platform.id}"
}
