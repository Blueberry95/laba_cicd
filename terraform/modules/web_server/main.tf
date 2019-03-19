data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name" 
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_elb" "elb" {
  name                = "${var.cluster_name}"
  subnets             = ["${var.subnet_id}"]
  security_groups     = ["${var.vpc_security_group_id}"]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 4
    timeout             = 30
    target              = "http:80/"
    interval            = 45
  }
}

resource "aws_launch_configuration" "lc_conf_prod" {
  name_prefix                 = "${var.cluster_name}_lc_prod_"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  security_groups             = ["${var.vpc_security_group_id}"]

  user_data = <<USER_DATA
#!/bin/bash
apt update -y
apt install apache2 -y
  USER_DATA

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