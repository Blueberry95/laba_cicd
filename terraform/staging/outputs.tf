output "instance_public_ip" {
  value = "${module.stage.instance_public_ip}"
}

output "instance_private_ip" {
  value = "${module.stage.instance_private_ip}"
}

output "instance_arn" {
  value = "${module.stage.instance_arn}"
}

output "instance_id" {
  value = "${module.stage.instance_id}"
}