variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  default = "labacicd"
}

variable "ami_id" {}

variable "key_name" {}

variable "bucket" {
  default = "labacicdterraform"
}