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

resource "aws_instance" "instance_stage" {
  count                       = "${1 - var.deploy_prod}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.public_ip}"
  vpc_security_group_ids      = ["${var.vpc_security_group_id}"]
  
  tags = {
    Name = "${var.cluster_name}_vm"
  }
}

resource "aws_eip" "eip" {
  count            = "${var.deploy_prod}"
  vpc              = true
}

resource "aws_lb" "lb" {
  count              = "${var.deploy_prod}"
  name_prefix        = "${var.cluster_name}_lb_"
  internal           = false
  load_balancer_type = "application"

  subnet_mapping {
    subnet_id     = "${var.subnet_id}"
    allocation_id = "${aws_eip.eip.*.id[count.index]}"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}_vm"
      propagate_at_launch = true
    }
  ]
}

resource "aws_launch_configuration" "lc_conf_prod" {
  count                       = "${var.deploy_prod}"
  name_prefix                 = "${var.cluster_name}_lc_"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  security_groups             = ["${var.vpc_security_group_id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_prod" {
  count                = "${var.deploy_prod}"
  name_prefix          = "${var.cluster_name}_ag_"
  launch_configuration = "${aws_launch_configuration.lc_conf_prod.*.name[count.index]}"
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

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  count                  = "${var.deploy_prod}"
  autoscaling_group_name = "${aws_autoscaling_group.asg_prod.*.id[count.index]}"
  elb                    = "${aws_lb.lb.*.id[count.index]}"
}