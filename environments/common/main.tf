
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.name}-${var.env}-key"
  public_key = var.ssh_public_key
}

data "aws_caller_identity" "current" {}

module "network" {
  source = "../../modules/network"

  cidr_block = var.vpc_cidr_block
  env = var.env
  name = var.name
  private_subnets = var.vpc_private_subnets
  public_subnets = var.vpc_public_subnets
  region = var.region
}

module "lambda_with_trigger" {
  count = 0
  source = "../../modules/lambda_with_trigger"

  env = var.env
  schedule = var.schedule
}

module "autoscaling_group" {
  count = 0
  source = "../../modules/autoscaling_group"

  name = var.name
  env = var.env
  desired_capacity = 0
  instance_type = "t3a.nano"
  max_size = 0
  min_size = 0
  ssh_key_name = aws_key_pair.ssh_key.key_name
  spot_price = ""
  subnets = module.network.public_subnet_ids
  volume_type = "gp3"
  volume_size = "8"
  vpc_id = module.network.vpc_id

  depends_on = [ module.network ]
}

module "ecs_with_alb" {
  count = 0
  source = "../../modules/ecs_with_alb"

  name = var.name
  env = var.env
  desired_capacity = 4
  instance_type = "t3a.small"
  max_size = 4
  min_size = 0
  ssh_key_name = aws_key_pair.ssh_key.key_name
  subnets = module.network.public_subnet_ids
  volume_type = "gp3"
  volume_size = "30"
  vpc_id = module.network.vpc_id

  depends_on = [ module.network ]
}

