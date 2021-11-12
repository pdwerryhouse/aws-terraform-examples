resource "aws_sns_topic" "sns" {
  name = "${var.name}-${var.env}-asg-lifecycle"
}
