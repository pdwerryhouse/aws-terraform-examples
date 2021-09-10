variable "env" { }
variable "name" { }
variable "region" { default = "us-west-2" }
variable "schedule" { }
variable "ssh_public_key" { }
variable "profile" { default = "default" }
variable "vpc_cidr_block" { }
variable "vpc_private_subnets" { type = list }
variable "vpc_public_subnets" { type = list }
