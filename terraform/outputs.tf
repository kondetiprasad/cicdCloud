output "nat-public-ip-a" {
  value = "${aws_eip.dev_nat_a.public_ip}"
}
output "nat-public-ip-b" {
  value = "${aws_eip.dev_nat_b.public_ip}"
}
output "app-elb" {
  value = "${aws_elb.dev_pub_elb.dns_name}"
}
output "mnt-elb" {
  value = "${aws_elb.dev_pub_elb_mnt.dns_name}"
}
output "monitor-elb" {
  value = "${aws_elb.dev_pub_elb_monitoring.dns_name}"
}
