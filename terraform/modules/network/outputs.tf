output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "vpc_arn" {
  value = "${aws_vpc.main_vpc.arn}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet.id}"
}
output "public_subnet_arn" {
  value = "${aws_subnet.public_subnet.arn}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.id}"
}
output "private_subnet_arn" {
  value = "${aws_subnet.private_subnet.arn}"
}

output "availability_zone" {
  value = "${data.aws_availability_zones.availability_zone.names[0]}"
}
