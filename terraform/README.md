# Terraform Setup
1. Download the terraform
```
wget https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip
```
2. Unzip terraform zip in /opt
```
cp terraform_0.6.16_linux_amd64.zip /opt
cd /opt
unzip terraform_0.6.16_linux_amd64.zip
```
3. update your /etc/environment by appending this
```
:/opt/terraform
like
export PATH="$PATH:/opt/terraform"
```

4. check the version to confirm that terraform it install properly
```
$ terraform --version
Terraform v0.6.16
```

5. Set the environment for aws creds
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

6. go to the terraform dir run terraform plan
```
$ terraform plan
```

7. If everything this goes well then run this command
```
$ terraform apply
```

8. to destory
```
$ terraform destory
```

### If the all instance up then put the config(xebia) file into your ~/.ssh directory and update NAT instance ips with your instance elasticIP

# Configuring servers
* Do puppet server setup
```
ssh dev.puppet.az.b.xebia.training.com
curl https://raw.githubusercontent.com/OpsTree/CloudAutomation/master/terraform/puppetmaster.sh | bash
```

* Setup MySQL server
```
ssh dev.mysql.az.a.xebia.training.com
puppet agent -t --debug
```

* Setup both nginx/proxy via puppet
```
ssh dev.proxy.az.a.xebia.training.com
puppet agent -t --debug
ssh dev.proxy.az.b.xebia.training.com
puppet agent -t --debug
```

* Setup jenkins server
```
ssh dev.jenkins.az.a.xebia.training.com
puppet agent -t
```
