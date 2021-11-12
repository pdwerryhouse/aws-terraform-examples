
# Autoscaling Group

This example creates a launch template, a security group and an
autoscaling group, which will launch an Ubuntu 20.04 Linux EC2 instance.

It also creates an SNS topic, with a demonstration of a lifecycle hook; a
notification is published whenever an EC2 instance is terminated.

## Parameters

| Parameter        | Description                             |
|------------------|-----------------------------------------|
| env              | Environment name ('dev', 'prod', etc)   |
| desired_capacity | Desired number of instances             |
| instance_type    | EC2 instance types                      |
| max_size         | Max size of autoscaling group           |
| min_size         | Min size of autoscaling group           |
| name             | Name of instances                       |
| spot_price       | Spot price in dollars or empty string   |
| subnets          | List of subnet IDs                      |
| volume_type      | EBS volume type                         |
| volume_size      | Size of root EBS volume in Gb           |
| vpc_id           | VPC ID                                  |

## Example

    module "autoscaling_group" {
      source = "../../../modules/autoscaling_group"
    
      name = "terraform-test"
      env = "dev"
      instance_type = "t3a.nano"
      ssh_key_name = "aws"
      spot_price = "0.86"
      subnets = [ "subnet-044068ac8111d390e", "subnet-02de40e5ebaf62306" ]
      volume_type = "gp2"
      volume_size = "20"
      vpc_id = "vpc-aabae1cf"
    
      depends_on = [ module.network ]
    }
