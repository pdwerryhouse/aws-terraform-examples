resource "aws_sns_topic" "sns" {
  name = "${var.name}-${var.env}-asg-lifecycle"
  kms_master_key_id = var.encrypt_sns == true ? aws_kms_key.key[0].id : ""
}
