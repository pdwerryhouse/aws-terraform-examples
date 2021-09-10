
# ECS with ALB

This example creates an ALB, a launch template, an autoscaling group, and
an ECS cluster using Amazon Linux 2, and deploys the nginxdemos/hello docker
image into them

## Parameters

| Parameter        | Description                             |
|------------------|-----------------------------------------|
| env              | Environment name ('dev', 'prod', etc)   |
| desired_capacity | Desired number of instances             |
| instance_type    | EC2 instance types                      |
| max_size         | Max size of autoscaling group           |
| min_size         | Min size of autoscaling group           |
| name             | Name of instances                       |
| subnets          | List of subnet IDs                      |
| volume_type      | EBS volume type                         |
| volume_size      | Size of root EBS volume in Gb           |
| vpc_id           | VPC ID                                  |

## Example

    module "ecs_with_alb" {
      source = "../../../modules/ecs_with_alb"
    
      name = "terraform-test"
      env = "dev"
      desired_capacity = 2
      instance_type = "t3a.small"
      max_size = 0
      min_size = 0
      ssh_key_name = "aws"
      subnets = [ "subnet-044068ac8111d390e", "subnet-02de40e5ebaf62306" ]
      volume_type = "gp2"
      volume_size = "20"
      vpc_id = "vpc-aabae1cf"
    
      depends_on = [ module.network ]
    }
