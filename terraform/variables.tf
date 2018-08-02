variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.

Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = "prasad.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "prasad"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

# NAT AMI (x64)
variable "aws_amis" {
  default = {
    us-west-2 = "ami-290f4119"
  }
}

# APP AMI 
variable "aws_appamis" {
  default = {
    us-west-2 = "ami-14b07274"
  }
}

# puppet master AMI
variable "aws_puppetami" {
  default = {
    us-west-2 = "ami-14b07274"
  }
}

# mysql AMI
variable "aws_mysqlami" {
  default = {
    us-west-2 = "ami-14b07274"
  }
}
