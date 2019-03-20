resource "aws_security_group" "custom_security" {
  name        = "${var.cluster_name}_sg"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "${var.cluster_name}_sg"
  }
}

resource "aws_security_group_rule" "custom_rule" {
  type            = "ingress"
  from_port       = "${var.port}"
  to_port         = "${var.port}"
  protocol        = "tcp"
  cidr_blocks     = ["${var.cidr_block}"]

  security_group_id = "${aws_security_group.custom_security.id}"
}
resource "aws_security_group_rule" "allow_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security.id}"
}

resource "aws_security_group" "custom_security_prod" {
  name        = "${var.cluster_name}_sg_prod"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "${var.cluster_name}_sg_prod"
  }
}

resource "aws_security_group_rule" "custom_rule_prod" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security_prod.id}"
}

resource "aws_security_group_rule" "custom_rule_prod_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security_prod.id}"
}
resource "aws_security_group_rule" "allow_all_prod" {
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security_prod.id}"
}

resource "aws_security_group" "custom_security_stage" {
  name        = "${var.cluster_name}_sg_stage"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name = "${var.cluster_name}_sg_stage"
  }
}

resource "aws_security_group_rule" "custom_rule_stage" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${var.vpc_cidr_block}"]

  security_group_id = "${aws_security_group.custom_security_stage.id}"
}

resource "aws_security_group_rule" "custom_rule_icmp_stage" {
  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = "icmp"
  cidr_blocks     = ["${var.vpc_cidr_block}"]

  security_group_id = "${aws_security_group.custom_security_stage.id}"
}

resource "aws_security_group_rule" "allow_all_stage" {
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.custom_security_stage.id}"
}