data "aws_availability_zones" "availability_zone" {}

resource "aws_vpc" "main_vpc" {
  cidr_block       = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.cluster_name}_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = {
    Name = "${var.cluster_name}_gw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "${var.public_subnet_cidr_block}"
  availability_zone = "${data.aws_availability_zones.availability_zone.names[0]}"

  tags = {
    Name = "${var.cluster_name}_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "${var.private_subnet_cidr_block}"
  availability_zone = "${data.aws_availability_zones.availability_zone.names[0]}"
 
  tags = {
    Name = "${var.cluster_name}_private_subnet"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "${var.cluster_name}_public_rt"
  }
}
resource "aws_route_table" "rt_private" {
  vpc_id = "${aws_vpc.main_vpc.id}"
}

resource "aws_route_table_association" "public_association" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "private_association" {
    subnet_id = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.rt_private.id}"
}
