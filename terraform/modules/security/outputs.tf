output "sg_id" {
  value = "${aws_security_group.custom_security.id}"
}

output "sg_arn" {
  value = "${aws_security_group.custom_security.arn}"
}

output "sg_name" {
  value = "${aws_security_group.custom_security.name}"
}

output "sg_id_prod" {
  value = "${aws_security_group.custom_security_prod.id}"
}

output "sg_arn_prod" {
  value = "${aws_security_group.custom_security_prod.arn}"
}

output "sg_name_prod" {
  value = "${aws_security_group.custom_security_prod.name}"
}

output "sg_id_stage" {
  value = "${aws_security_group.custom_security_stage.id}"
}

output "sg_arn_stage" {
  value = "${aws_security_group.custom_security_stage.arn}"
}

output "sg_name_stage" {
  value = "${aws_security_group.custom_security_stage.name}"
}