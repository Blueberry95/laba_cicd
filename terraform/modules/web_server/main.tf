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

resource "aws_instance" "instance" {
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
