terraform {
  backend "s3" {
    bucket = "labacicdterraform"
    key    = "prod/prod.tfstate"
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

module "prod" {
  source                = "../modules/web_server"
  cluster_name          = "${data.terraform_remote_state.base_state.cluster_name}"
  subnet_id             = "${data.terraform_remote_state.base_state.public_subnet_id}"
  vpc_security_group_id = "${data.terraform_remote_state.base_state.sg_id_prod}"
  key_name              = "${var.key_name}"
  public_ip             = "${var.public_ip}"
  ami_id                = "${var.ami_id}"
}