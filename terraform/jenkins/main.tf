terraform {
  backend "s3" {
    bucket = "labacicdterraform"
    key    = "jenkins_and_vpc/baseterraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source         = "../modules/network"
  cluster_name   = "${var.cluster_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "security" {
  source         = "../modules/security"
  vpc_id         = "${module.network.vpc_id}"
  cluster_name   = "${var.cluster_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "jenkins" {
  source                = "../modules/jenkins"
  cluster_name          = "${var.cluster_name}"
  subnet_id             = "${module.network.public_subnet_id}"
  vpc_security_group_id = "${module.security.sg_id}"
  ami_id                = "${var.ami_id}"
  key_name              = "${var.key_name}"
}