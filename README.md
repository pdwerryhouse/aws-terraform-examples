
# AWS Terraform Examples

This repository contains useful examples of Terraform code.

| Name                | Description                                    |
|---------------------|------------------------------------------------|
| autoscaling_group   | An autoscaling group of EC2 instances          |
| ecs_with_alb        | An ECS cluster behind an ALB                   |
| lambda_with_trigger | A lambda with a scheduled trigger              |
| network             | VPC and subnets                                |

### Usage

    aws configure
    cd environments/aws/dev

    # copy your ssh public key into key.auto.tfvars
    key=$(cat ~/.ssh/id_rsa.pub)
    echo "ssh_public_key = \"${key}\"" > key.auto.tfvars

    # edit the main.tf file and set "count = 1" on the modules that you want
    # to use
    vi main.tf

    terraform init
    terraform plan
    terraform apply

