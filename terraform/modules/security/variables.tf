variable "cluster_name" {
  default = "kisa"
}

variable "vpc_id" {}

variable "port" {
  default = 8080
}

variable "cidr_block" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr_block" {
  default = "0.0.0.0/0"
}