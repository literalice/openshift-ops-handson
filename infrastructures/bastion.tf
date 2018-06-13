resource "aws_iam_instance_profile" "bastion" {
  name = "${local.platform_id}-bastion-profile"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_instance" "bastion" {
  ami                         = "${data.aws_ami.bastion.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.platform.id}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.bastion.name}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "32"
  }

  tags = "${map(
    "Name", "${local.platform_id}-bastion",
    "Role", "bastion"
  )}"
}

resource "null_resource" "bastion_platform_key" {
  provisioner "file" {
    content     = "${data.tls_public_key.platform.private_key_pem}"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/id_rsa",
    ]
  }

  connection {
    type        = "ssh"
    user        = "${local.bastion_ssh_user}"
    private_key = "${data.tls_public_key.platform.private_key_pem}"
    host        = "${aws_instance.bastion.public_ip}"
  }

  triggers = {
    bastion_instance_id = "${aws_instance.bastion.id}"
  }

  depends_on = ["aws_instance.bastion"]
}
