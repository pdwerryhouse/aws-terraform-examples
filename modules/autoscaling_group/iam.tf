resource "aws_iam_policy" "publish" {
  name = "${var.name}-${var.env}-sns-publish-policy"
  path = "/"
  description = "SNS Publish policy for ${var.name}-${var.env}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.sns.arn}",
      "Action": [
        "sns:Publish"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "kms:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "logs:*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role" "publish" {
  name = "${var.name}-${var.env}-sns-publish-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
  
}
EOF
}

resource "aws_iam_role_policy_attachment" "publish" {
  role = aws_iam_role.publish.name
  policy_arn = aws_iam_policy.publish.arn
}
