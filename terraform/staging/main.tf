terraform {
  backend "s3" {
    bucket = "labacicdterraform"
    key    = "staging/staging.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "base_state" {
  backend = "s3"
  config {
    bucket = "${var.bucket}"
    key    = "jenkins_and_vpc/baseterraform.tfstate"
    region = "${var.region}"
  }
}

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

resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${var.key_name_pub}"
}

data "template_file" "userdata" {
  template = "#!/bin/bash\n${file("./user_data/install_tomcat.tpl")}"
}

resource "aws_instance" "instance_stage" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.deployer.key_name}"
  subnet_id                   = "${data.terraform_remote_state.base_state.public_subnet_id}"
  associate_public_ip_address = "${var.public_ip}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.base_state.sg_id_stage}"]

  user_data                   = "${data.template_file.userdata.rendered}"

  tags = {
    Name = "${data.terraform_remote_state.base_state.cluster_name}_stage"
  }
}