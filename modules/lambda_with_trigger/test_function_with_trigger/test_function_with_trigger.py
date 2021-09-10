#!/usr/bin/env python3

import boto3
import json

def lambda_handler(event, context):
    
    client = boto3.client('ec2')
    response = client.describe_instances()

    for reservation in response.get('Reservations'):
        for instance in reservation.get('Instances'):
            print(instance.get('InstanceId'))

    return {
        'statusCode': 200,
        'body': json.dumps('Success')
    }

if __name__ == '__main__':
    lambda_handler(None, None)
