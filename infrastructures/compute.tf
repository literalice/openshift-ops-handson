resource "aws_iam_instance_profile" "compute" {
  name = "${local.platform_id}-compute-profile"
  role = "${aws_iam_role.compute.name}"
}

resource "aws_instance" "computes" {
  count                       = "${var.compute_node_count}"
  ami                         = "${data.aws_ami.node.id}"
  instance_type               = "m4.large"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.platform.id}"

  vpc_security_group_ids = ["${aws_security_group.node.id}"]

  iam_instance_profile = "${aws_iam_instance_profile.compute.name}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "64"
  }

  user_data = "${file("${path.module}/resources/node-init.yml")}"

  tags = "${map(
    "Name", "${local.platform_id}-compute${count.index}",
    "kubernetes.io/cluster/${local.platform_id}", "owned",
    "Role", "compute"
  )}"
}
