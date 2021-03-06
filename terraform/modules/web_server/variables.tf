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
  default = true
}

variable "vpc_security_group_id" {
  default = ""
}

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "1"
}

variable "ami_id" {}

variable "user_data" {}
