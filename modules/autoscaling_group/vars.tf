variable "env"                { }
variable "instance_type"      { default = "t3a.nano" }
variable "ssh_key_name"       { }
variable "desired_capacity"   { default = "0" }
variable "max_size"           { default = "0" }
variable "min_size"           { default = "0" }
variable "name"               { }
variable "spot_price"         { default = "" }
variable "subnets"            { }
variable "volume_type"        { default = "gp2" }
variable "volume_size"        { default = "20" }
variable "vpc_id"             { }
