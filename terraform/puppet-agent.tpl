#!/usr/bin/env bash

### This will log all logs on provision process to "/var/log/user-data.log"
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
yum -y install puppet wget deltarpm

ENVIRONMENT="${ENVIRONMENT}"
COMPONENT="${COMPONENT}"
AZ="${AZ}"
FACTER="${FACTER}"
local_ip=`wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`
cat >/etc/hosts << EOL
127.0.0.1   localhost ${COMPONENT}.${ENVIRONMENT}.az.${AZ}.demo.training.com localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$local_ip   ${COMPONENT}-${ENVIRONMENT}-az-${AZ}.demo.training.com ${COMPONENT}-${ENVIRONMENT}-az-${AZ}
EOL

cat >/etc/sysconfig/network << EOL
HOSTNAME=${COMPONENT}-${ENVIRONMENT}-az-${AZ}
NETWORKING=yes
EOL

hostname ${COMPONENT}-${ENVIRONMENT}-az-${AZ}
/etc/init.d/network restart

cat >/etc/puppetlabs/puppet/puppet.conf << EOL 
[main]
    environment=production
    certname=${COMPONENT}-${ENVIRONMENT}-az-${AZ}.demo.training.com

[agent]
    server=puppet-dev-az-b.demo.training.com
    report=true
    runinterval=600
EOL

service puppet start
echo "export FACTER_roles=${FACTER}" >> /etc/bashrc
