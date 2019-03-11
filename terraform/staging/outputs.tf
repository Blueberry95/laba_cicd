output "instance_public_ip" {
  value = "${module.stage_vm.instance_public_ip}"
}

output "instance_private_ip" {
  value = "${module.stage_vm.instance_private_ip}"
}

output "instance_arn" {
  value = "${module.stage_vm.instance_arn}"
}

output "instance_id" {
  value = "${module.stage_vm.instance_id}"
}