variable "key_name" {
  default = "stage_key"
}

variable "key_name_pub" {
  default = "stage_key"
}

variable "region" {
  default = "us-east-2"
}

variable "bucket" {
  default = "labacicdterraform"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_ip" {
  default = true
}