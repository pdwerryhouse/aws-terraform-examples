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

resource "aws_iam_policy" "lambda_policy" {
  name          = "Test_Function_With_Trigger-${var.env}-policy"
  path          = "/"
  description   = "Policy for Test_Function_With_Trigger"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Resource": "*",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role" "lambda_role" {
  name          = "Test_Function_With_Trigger-${var.env}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role          = aws_iam_role.lambda_role.name
  policy_arn    = aws_iam_policy.lambda_policy.arn
}
