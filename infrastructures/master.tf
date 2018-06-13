resource "aws_iam_instance_profile" "master" {
  name = "${local.platform_id}-master-profile"
  role = "${aws_iam_role.master.name}"
}

resource "aws_instance" "masters" {
  count                       = 1
  ami                         = "${data.aws_ami.node.id}"
  instance_type               = "m4.xlarge"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.platform.id}"

  vpc_security_group_ids = [
    "${aws_security_group.node.id}",
    "${aws_security_group.master_public.id}",
    "${aws_security_group.public.id}",
  ]

  root_block_device = {
    volume_type = "gp2"
    volume_size = "64"
  }

  user_data = "${file("${path.module}/resources/node-init.yml")}"

  iam_instance_profile = "${aws_iam_instance_profile.master.name}"

  tags = "${map(
    "Name", "${local.platform_id}-master",
    "kubernetes.io/cluster/${local.platform_id}", "owned",
    "Role", "master"
  )}"
}
