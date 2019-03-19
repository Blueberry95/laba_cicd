output "instance_public_ip" {
  value = "${aws_instance.instance_stage.*.public_ip}"
}

output "instance_private_ip" {
  value = "${aws_instance.instance_stage.*.private_ip}"
}

output "instance_arn" {
  value = "${aws_instance.instance_stage.*.arn}"
}

output "instance_id" {
  value = "${aws_instance.instance_stage.*.id}"
}

output "elastic_ip" {
  value = "${aws_eip.eip.*.public_ip }"
}