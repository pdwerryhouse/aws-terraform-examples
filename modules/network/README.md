
# Network Module

This example creates a VPC, an internet gateway, two public subnets and
configures appropriate route tables.

## Parameters

| Parameter         | Description                             |
|-------------------|-----------------------------------------|
| cidr_block        | Range of IP addresses for the VPC       |
| env               | Environment name ('dev', 'prod', etc)   |
| name              | Name of the VPC                         |
| public_subnets    | List of networks for public subnets     |
| private_subnets   | List of networks for private subnets    |
| region            | AWS region name                         |

## Outputs

| Parameter          | Description                             |
|--------------------|-----------------------------------------|
| public_subnet_id   | IDs of public subnets                   |
| private_subnet_ids | IDs of public subnets                   |
| vpc_id             | VPC ID                                  |

## Example

    module "network" {
      source = "../../../modules/network"
    
      cidr_block = "10.0.0.0/16"
      env = "dev"
      name = "terraform-test"
      private_subnets = [ "10.0.128.0/24", "10.0.129.0/24" ]
      public_subnets = [ "10.0.0.0/24", "10.0.1.0/24" ]
      region = "us-west-2"
    }

