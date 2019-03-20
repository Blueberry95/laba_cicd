output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "vpc_arn" {
  value = "${module.network.vpc_arn}"
}

output "public_subnet_id" {
  value = "${module.network.public_subnet_id}"
}
output "public_subnet_arn" {
  value = "${module.network.public_subnet_arn}"
}

output "private_subnet_id" {
  value = "${module.network.private_subnet_id}"
}
output "private_subnet_arn" {
  value = "${module.network.private_subnet_arn}"
}

output "availability_zone" {
  value = "${module.network.availability_zone}"
}

output "sg_id" {
  value = "${module.security.sg_id}"
}

output "sg_arn" {
  value = "${module.security.sg_arn}"
}

output "sg_name" {
  value = "${module.security.sg_name}"
}

output "sg_id_prod" {
  value = "${module.security.sg_id_prod}"
}

output "sg_arn_prod" {
  value = "${module.security.sg_arn_prod}"
}

output "sg_name_prod" {
  value = "${module.security.sg_name_prod}"
}

output "sg_id_stage" {
  value = "${module.security.sg_id_stage}"
}

output "sg_arn_stage" {
  value = "${module.security.sg_arn_stage}"
}

output "sg_name_stage" {
  value = "${module.security.sg_name_stage}"
}

output "cluster_name" {
  value = "${var.cluster_name}"
}

output "artifact_bucket_name" {
  value = "${aws_s3_bucket.bucket.id}"
}