
# Lambda With Cloudwatch Event Trigger

This is an example of creating a Lambda function with a Cloudwatch Event
trigger.

## Parameters

| Parameter | Description                             |
|-----------|-----------------------------------------|
| env       | Environment name ('dev', 'prod', etc)   |
| schedule  | Cloudwatch Event Schedule expression    |


## Example

    module "lambda_with_trigger" {
      source = "../../../modules/lambda_with_trigger"
    
      env = var.env
      schedule = var.schedule
    }
    
