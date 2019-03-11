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

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "1"
}

variable "launch_autoscaling" {
  default = false
}

variable "vpc_security_group_id" {}

variable "public_ip" {
  default = true
}

variable "ami_id" {}