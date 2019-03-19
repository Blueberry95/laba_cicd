variable "cluster_name" {
  default = "kisa"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "AnastasiiaK"
}
variable "subnet_id" {
  default = ""
}

variable "public_ip" {
  default = false
}

variable "vpc_security_group_id" {
  default = ""
}

variable "deploy_prod" {}

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "1"
}