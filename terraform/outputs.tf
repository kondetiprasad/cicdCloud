output "nat-public-ip-a" {
  value = "${aws_eip.dev_nat_a.public_ip}"
}
output "nat-public-ip-b" {
  value = "${aws_eip.dev_nat_b.public_ip}"
}
output "app-elb" {
  value = "${aws_elb.dev_pub_elb.dns_name}/Spring3HibernateApp"
}
output "jenkins" {
  value = "${aws_elb.dev_pub_elb_mnt.dns_name}"
}
output "sonar" {
  value = "${aws_elb.dev_pub_elb_mnt.dns_name}:9000"
}
output "nexus" {
  value = "${aws_elb.dev_pub_elb_mnt.dns_name}:8081"
}
output "zabbix" {
  value = "${aws_elb.dev_pub_elb_monitoring.dns_name}"
}
output "kibana" {
  value = "${aws_elb.dev_pub_elb_monitoring.dns_name}:5601"
}
