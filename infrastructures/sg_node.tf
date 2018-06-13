resource "aws_security_group" "node" {
  name        = "${local.platform_id}-node"
  description = "Cluster node group for ${local.platform_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${local.platform_id}", "owned",
    "Name", "${local.platform_id}-node",
    "Role", "node",
    )}"

  vpc_id = "${aws_vpc.platform.id}"
}
