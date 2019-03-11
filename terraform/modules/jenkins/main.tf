resource "aws_launch_configuration" "lc_conf" {
  name_prefix                 = "${var.cluster_name}_lc_"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.iam_profile.name}"
  associate_public_ip_address = "${var.public_ip}"
  security_groups             = ["${var.vpc_security_group_id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix          = "${var.cluster_name}_ag_"
  launch_configuration = "${aws_launch_configuration.lc_conf.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnet_id}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}_vm"
      propagate_at_launch = true
    }
  ]
}

resource "aws_iam_role" "admin_role" {
  name  = "${var.cluster_name}_admin_role"

  assume_role_policy = <<EOF
{
   "Version" : "2012-10-17",
   "Statement": [ {
      "Effect": "Allow",
      "Principal": {
         "Service": [ "ec2.amazonaws.com" ]
      },
      "Action": [ "sts:AssumeRole" ]
   } ]
}
EOF

  tags = {
      Name = "${var.cluster_name}_admin_role"
  }
}
resource "aws_iam_policy" "root_policy" {
  name        = "${var.cluster_name}_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_role" {
  role       = "${aws_iam_role.admin_role.name}"
  policy_arn = "${aws_iam_policy.root_policy.arn}"
}
resource "aws_iam_instance_profile" "iam_profile" {
  name  = "${var.cluster_name}_iam_profile"
  role  = "${aws_iam_role.admin_role.name}"
}