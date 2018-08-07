# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/19"
  tags {
    Name = " Employee Record VPC"
    Project = "Employee Record"
  }
  enable_dns_hostnames = "true"
}

# Create an internet gateway toF give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = " Employee Record IGW"
    Project = "Employee Record"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our public instances into
resource "aws_subnet" "dev_public_a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/27"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags {
    Name = " Employee Record public subnet az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}
resource "aws_subnet" "dev_public_b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.2.0/27"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"
  tags {
    Name = " Employee Record public subnet az b"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

# Our nat security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default_nat" {
  name        = "nat_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 11371
    to_port     = 11371
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9418
    to_port     = 9418
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "dev_nat_a" {
  instance_type = "t2.small"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.default_nat.id}"]
  subnet_id = "${aws_subnet.dev_public_a.id}"
  source_dest_check = "false" 
  tags {
    Name = "dev.nat.az.a.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_instance" "dev_nat_b" {
  instance_type           = "t2.small"
  ami                     = "${lookup(var.aws_amis, var.aws_region)}"
  key_name                = "${aws_key_pair.auth.id}"
  vpc_security_group_ids  = ["${aws_security_group.default_nat.id}"]
  subnet_id               = "${aws_subnet.dev_public_b.id}"
  source_dest_check       = "false"
  tags {
    Name          = "dev.nat.az.b.demo.training.com"
    Project       = "Employee Record"
    Environtment  = "Development"
  }
}

resource "aws_subnet" "dev_maintainance_sub_a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}a"
 # map_public_ip_on_launch = true
  tags {
    Name = "maintainance subnet az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_subnet" "dev_maintainance_sub_b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.aws_region}b"
  tags {
    Name = "maintainance subnet az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_subnet" "dev_application_sub_a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "${var.aws_region}a"
  tags {
    Name = "application subnet az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_subnet" "dev_application_sub_b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.6.0/27"
  availability_zone       = "${var.aws_region}b"
  tags {
    Name = "application subnet az b"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_subnet" "dev_db_sub_a" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "${var.aws_region}a"
  tags {
    Name = "database subnet az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_subnet" "dev_db_sub_b" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.8.0/27"
  availability_zone       = "${var.aws_region}b"
  tags {
    Name = "application subnet az b"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_route_table" "route_table_a" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.dev_nat_a.id}"
  }
  tags {
    Name = "route table az a"
    Project = "Employee Record"
  }
}

resource "aws_route_table" "route_table_b" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.dev_nat_b.id}"
  }
  tags {
    Name = "route table az b"
    Project = "Employee Record"
  }
}

resource "aws_route_table_association" "dev_application_sub_a" {
    subnet_id = "${aws_subnet.dev_application_sub_a.id}"
    route_table_id = "${aws_route_table.route_table_a.id}"
}

resource "aws_route_table_association" "dev_application_sub_b" {
    subnet_id = "${aws_subnet.dev_application_sub_b.id}"
    route_table_id = "${aws_route_table.route_table_b.id}"
}

resource "aws_route_table_association" "dev_maintainance_sub_a" {
    subnet_id = "${aws_subnet.dev_maintainance_sub_a.id}"
    route_table_id = "${aws_route_table.route_table_a.id}"
}

resource "aws_route_table_association" "dev_maintainance_sub_b" {
    subnet_id = "${aws_subnet.dev_maintainance_sub_b.id}"
    route_table_id = "${aws_route_table.route_table_b.id}"
}

resource "aws_route_table_association" "dev_db_sub_a" {
    subnet_id = "${aws_subnet.dev_db_sub_a.id}"
    route_table_id = "${aws_route_table.route_table_a.id}"
}

resource "aws_route_table_association" "dev_db_sub_b" {
    subnet_id = "${aws_subnet.dev_db_sub_b.id}"
    route_table_id = "${aws_route_table.route_table_b.id}"
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10052
    to_port     = 10052
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "application security group"
    Project = "Employee Record"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10052
    to_port     = 10052
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "database security group"
    Project = "Employee Record"
  }
}

resource "aws_security_group" "maintainance_sg" {
  name        = "maintainance_sg"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10052
    to_port     = 10052
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "mainainance security group az a"
    Project = "Employee Record"
  }
}

resource "template_file" "app-puppet-agent-aza" {
    template = "${file("puppet-agent.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "app"
        AZ="a"
        FACTER="tomcat"
    }
}

resource "aws_instance" "dev_app_a" {
  instance_type = "t2.small"
  ami = "${lookup(var.aws_appamis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
  subnet_id = "${aws_subnet.dev_application_sub_a.id}"
  user_data = "${template_file.app-puppet-agent-aza.rendered}"
  tags {
    Name = "dev.app.az.a.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "template_file" "app-puppet-agent-azb" {
    template = "${file("puppet-agent.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "app"
        AZ="b"
	FACTER="tomcat"
    }
}

resource "aws_instance" "dev_app_b" {
  instance_type = "t2.small"
  ami = "${lookup(var.aws_appamis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]
  subnet_id = "${aws_subnet.dev_application_sub_b.id}"
  user_data = "${template_file.app-puppet-agent-azb.rendered}"
  tags {
    Name = "dev.app.az.b.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "template_file" "db-puppet-agent-aza" {
    template = "${file("puppet-agent.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "mysql"
        AZ="a"
	FACTER="mysql"
    }
}

resource "aws_instance" "dev_db_a" {
  instance_type = "t2.small"
  ami = "${lookup(var.aws_mysqlami, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  subnet_id = "${aws_subnet.dev_db_sub_a.id}"
  user_data = "${template_file.db-puppet-agent-aza.rendered}"
  tags {
    Name = "dev.mysql.az.a.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "template_file" "jenkins-puppet-agent-aza" {
    template = "${file("puppet-agent.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "jenkins"
        AZ="a"
	FACTER="jenkins"
    }
}

resource "aws_instance" "maintainance_jenkins" {
  instance_type = "t2.medium"
  ami = "${lookup(var.aws_appamis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.maintainance_sg.id}"]
  subnet_id = "${aws_subnet.dev_maintainance_sub_a.id}"
  user_data = "${template_file.jenkins-puppet-agent-aza.rendered}"
  tags {
    Name = "dev.jenkins.nexus.sonar.az.a.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "template_file" "puppetmaster-puppet-agent-azb" {
    template = "${file("puppet-master.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "puppet"
        AZ="b"
	FACTER="puppet"
    }
}

resource "aws_instance" "maintainance_puppet" {
  instance_type = "t2.small"
  ami = "${lookup(var.aws_puppetami, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  depends_on = ["aws_instance.dev_nat_a", "aws_instance.dev_nat_b"]
  vpc_security_group_ids = ["${aws_security_group.maintainance_sg.id}"]
  subnet_id = "${aws_subnet.dev_maintainance_sub_b.id}"
  user_data = "${template_file.puppetmaster-puppet-agent-azb.rendered}"  
  tags {
    Name = "dev.puppet.az.b.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

# Template for initial configuration bash script
resource "template_file" "zabbix-puppet-agent-azb" {
    template = "${file("puppet-agent.tpl")}"

    vars {
        ENVIRONMENT= "dev"
        COMPONENT= "zabbix"
        AZ="b"
	FACTER="puppet"
    }
}

resource "aws_instance" "maintainance_zabbix" {
  instance_type = "t2.medium"
  ami = "${lookup(var.aws_appamis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.maintainance_sg.id}"]
  subnet_id = "${aws_subnet.dev_maintainance_sub_b.id}"
  user_data = "${template_file.zabbix-puppet-agent-azb.rendered}"
  tags {
    Name = "dev.zabbix.az.b.demo.training.com"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "ELB security group"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "ELB security group az a"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_elb" "dev_pub_elb" {
  name = "Employee-Record-elb"

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "tcp:8080"
    interval = 30
  }
  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets = ["${aws_subnet.dev_public_a.id}","${aws_subnet.dev_public_b.id}"]
  instances = ["${aws_instance.dev_app_a.id}","${aws_instance.dev_app_b.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "public facing ELB group"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

resource "aws_lb_cookie_stickiness_policy" "dev_session" {
      name = "elb-policy"
      load_balancer = "${aws_elb.dev_pub_elb.id}"
      lb_port = 80
      cookie_expiration_period = 600
}
resource "aws_route53_record" "dev_elb_sonar" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "sonar"
    type = "CNAME"
    ttl = "30"
    records = ["${aws_elb.dev_pub_elb.dns_name}"]
}

resource "aws_route53_record" "dev_elb_demo" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "test"
    type = "CNAME"
    ttl = "30"
    records = ["${aws_elb.dev_pub_elb.dns_name}"]
}

resource "aws_route53_zone" "development" {
  name = "demo.training.com"
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "internal DNS for development env"
    Project = "Employee Record"
    Environtment = "Development"    
  }
}

resource "aws_route53_record" "dev_app_a" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "app-dev-az-a"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.dev_app_a.private_ip}"]
}

resource "aws_route53_record" "dev_app_b" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "app-dev-az-b"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.dev_app_b.private_ip}"]
}

resource "aws_route53_record" "dev_db_a" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "mysql-dev-az-a"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.dev_db_a.private_ip}"]
}

resource "aws_route53_record" "dev_maintainance_jenkins" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "jenkins-dev-az-a"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.maintainance_jenkins.private_ip}"]
}

resource "aws_route53_record" "dev_maintainance_puppet" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "puppet-dev-az-b"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.maintainance_puppet.private_ip}"]
}

resource "aws_route53_record" "dev_maintainance_zabbix" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "zabbix-dev-az-b"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.maintainance_zabbix.private_ip}"]
}

resource "aws_route53_record" "dev_nat_a" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "nat-dev-az-a"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.dev_nat_a.private_ip}"]
}

resource "aws_route53_record" "dev_nat_b" {
    zone_id = "${aws_route53_zone.development.zone_id}"
    name = "nat-dev-az-b"
    type = "A"
    ttl = "30"
    records = ["${aws_instance.dev_nat_b.private_ip}"]
}

resource "aws_eip" "dev_nat_a" {
  instance = "${aws_instance.dev_nat_a.id}"
  vpc      = true
}

resource "aws_eip" "dev_nat_b" {
  instance = "${aws_instance.dev_nat_b.id}"
  vpc      = true
}

## elb for maintenance
resource "aws_elb" "dev_pub_elb_mnt" {
  name = "Employee-Record-mnt-elb"

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 9000
    instance_protocol = "http"
    lb_port = 9000
    lb_protocol = "http"
  }

  listener {
    instance_port = 8081
    instance_protocol = "http"
    lb_port = 8081
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "tcp:8080"
    interval = 30
  }

  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets = ["${aws_subnet.dev_public_a.id}","${aws_subnet.dev_public_b.id}"]
  instances = ["${aws_instance.maintainance_jenkins.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "public facing ELB group fot mnt"
    Project = "Employee Record"
    Environtment = "Development"
  }
}

## elb for maintenance
resource "aws_elb" "dev_pub_elb_monitoring" {
  name = "Employee-Record-monitoring-elb"

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 5601
    instance_protocol = "http"
    lb_port = 5601
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "tcp:80"
    interval = 30
  }

  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets = ["${aws_subnet.dev_public_a.id}","${aws_subnet.dev_public_b.id}"]
  instances = ["${aws_instance.maintainance_zabbix.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "public facing ELB group fot monitoring"
    Project = "Employee Record"
    Environtment = "Development"
  }
}
