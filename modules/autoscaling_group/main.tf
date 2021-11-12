#    Terraform Examples
#    Copyright (C) 2021 Paul Dwerryhouse <paul@dwerryhouse.com.au>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

data "aws_ami" "ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_launch_template" "ecs-launch-template" {
  image_id                  = data.aws_ami.ami.id
  instance_type             = var.instance_type
  key_name                  = var.ssh_key_name
  ebs_optimized             = true
  update_default_version    = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_type           = var.volume_type
      volume_size           = var.volume_size
    }
  }

  instance_market_options {
    market_type = "spot"
    
    spot_options {
      max_price = var.spot_price
    }
  }

  vpc_security_group_ids = [ aws_security_group.asg.id ]
}

resource "aws_autoscaling_group" "asg" {
  name                  = "${var.name}-${var.env}"
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  vpc_zone_identifier   = var.subnets

  launch_template {
    id = aws_launch_template.ecs-launch-template.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "${var.name}-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key = "ami"
    value = data.aws_ami.ami.id
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = var.env
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "foobar" {
  name                   = "foobar"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_target_arn = aws_sns_topic.sns.id
  role_arn                = aws_iam_role.publish.arn
}

resource "aws_security_group" "asg" {
  name = "${var.name}-${var.env}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
