output "instance_public_ip" {
  value = "${module.prod.elastic_ip}"
}