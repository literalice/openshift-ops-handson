data "aws_iam_policy_document" "compute" {
  statement {
    actions = [
      "ec2:*",
      "ec2:AttachVolume",
      "ssm:GetDocument",
      "ec2:DetachVolume",
      "elasticloadbalancing:*",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "compute" {
  name               = "${var.platform_name}-compute-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_role_policy" "compute" {
  name   = "${var.platform_name}-compute-policy"
  role   = "${aws_iam_role.compute.id}"
  policy = "${data.aws_iam_policy_document.compute.json}"
}
