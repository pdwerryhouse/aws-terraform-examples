# KMS keys are expensive, so we make this optional with the 
# encrypt_sns parameter

data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"

  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::${var.aws_account_id}:root" ]
    }
  }

  statement {
    sid = "Allow SNS"
    effect = "Allow"
    resources = ["*"]
    actions   = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::${var.aws_account_id}:role/terraform-test-sandbox-sns-publish-role"]
    }
  }

}

resource "aws_kms_key" "key" {
  count                   = var.encrypt_sns == true ? 1 : 0
  description             = "${var.name}-${var.env} SNS KMS key"
  deletion_window_in_days = 7
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_kms_alias" "key" {
  count                   = var.encrypt_sns == true ? 1 : 0
  name                    = "alias/${var.name}-${var.env}-sns"
  target_key_id           = aws_kms_key.key[0].key_id
}

