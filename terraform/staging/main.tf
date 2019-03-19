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

module "stage" {
  source                = "../modules/web_server"
  cluster_name          = "${data.terraform_remote_state.base_state.cluster_name}"
  subnet_id             = "${data.terraform_remote_state.base_state.private_subnet_id}"
  vpc_security_group_id = "${data.terraform_remote_state.base_state.sg_id_stage}"
  key_name              = "${var.key_name}"
  deploy_prod           = false
}