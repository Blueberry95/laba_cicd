resource "aws_elb" "elb" {
  name                = "${var.cluster_name}"
  subnets             = ["${var.subnet_id}"]
  security_groups     = ["${var.vpc_security_group_id}"]
  listener {
    lb_port           = 80
    lb_protocol       = "tcp"
    instance_port     = 8080
    instance_protocol = "tcp"
  }
  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 8
    timeout             = 30
    target              = "tcp:22"
    interval            = 60
  }
}

resource "aws_launch_configuration" "lc_conf_prod" {
  name_prefix                 = "${var.cluster_name}_lc_prod_"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  security_groups             = ["${var.vpc_security_group_id}"]
  user_data                   = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_prod" {
  name                      = "${aws_launch_configuration.lc_conf_prod.name}"
  launch_configuration      = "${aws_launch_configuration.lc_conf_prod.name}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  vpc_zone_identifier       = ["${var.subnet_id}"]
  load_balancers            = ["${aws_elb.elb.name}"]
  health_check_grace_period = 120
  health_check_type         = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}_asg"
      propagate_at_launch = true
    }
  ]
}