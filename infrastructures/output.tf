output "bastion_instance_id" {
  value = "${aws_instance.bastion.id}"
}

output "bastion_ssh" {
  value = "${local.bastion_ssh_user}@${aws_instance.bastion.public_dns}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}

output "hosts_file" {
  value = "${element(aws_instance.masters.*.public_ip, 0)} master.ocp.example.com"
}
