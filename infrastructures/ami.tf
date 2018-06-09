data "aws_ami" "bastion" {
  owners      = ["309956199498"]
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.5_HVM_GA-????????-x86_64-*-Access2-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "node" {
  owners      = ["309956199498"]
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-Atomic_7.5_HVM_GA-????????-x86_64-*-Access2-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  bastion_ssh_user = "ec2-user"
  node_ssh_user    = "cloud-user"
}
