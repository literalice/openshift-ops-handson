resource "aws_security_group" "bastion" {
  name        = "${local.platform_id}-bastion"
  description = "Bastion group for ${local.platform_id}"

  ingress {
    from_port   = 22
    to_port     = 22
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
    "Name", "${local.platform_id}-bastion",
    "Role", "bastion"
  )}"

  vpc_id = "${aws_vpc.platform.id}"
}
