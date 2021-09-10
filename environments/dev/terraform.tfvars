env             = "dev"
name            = "terraform-test"
schedule        = "cron(0 12 * * ? *)"
vpc_cidr_block  = "10.0.0.0/16"
vpc_private_subnets = [ "10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24", "10.0.131.0/24" ]
vpc_public_subnets = [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
