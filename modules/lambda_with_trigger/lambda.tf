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


data "archive_file" "test_function_with_trigger" {
  type = "zip"
  source_dir = "${path.module}/test_function_with_trigger"
  output_path = "${path.module}/test_function_with_trigger.zip"
}

resource "aws_lambda_function" "lambda" {
    function_name = "test_function_with_trigger"
    handler = "test_function_with_trigger.lambda_handler"
    runtime = "python3.7"
    publish = "true"
    filename = "${path.module}/test_function_with_trigger.zip"
    source_code_hash = data.archive_file.test_function_with_trigger.output_base64sha256
    role = aws_iam_role.lambda_role.arn
}

resource "aws_cloudwatch_event_rule" "lambda_trigger" {
    name = "lambda-trigger"
    description = "Scheduled Lambda Trigger"
    schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "event_target" {
    rule = aws_cloudwatch_event_rule.lambda_trigger.name
    target_id = "event_target"
    arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "lambda_permission" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.lambda_trigger.arn
}
