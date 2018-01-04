#!/usr/bin/python
from __future__ import print_function
import boto3
import botocore.exceptions
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--VpcId', required=True)
parser.add_argument('--ExternalCidr', required=True)
parser.add_argument('--InternalCidr', required=True)
args = parser.parse_args()

stack_name = 'elixir-cluster'

client = boto3.client('cloudformation', region_name='ap-southeast-2')

with open('cloudformation.yaml', 'r') as template:
    templateBody = template.read()

tags = [
    {'Key': 'Project', 'Value': stack_name}
]

parameters = [
    {'ParameterKey': 'VpcId', 'ParameterValue': args.VpcId},
    {'ParameterKey': 'ExternalCidr', 'ParameterValue': args.ExternalCidr},
    {'ParameterKey': 'InternalCidr', 'ParameterValue': args.InternalCidr}
]

try:
    print('STACK CREATED:', client.create_stack(StackName=stack_name, TemplateBody=templateBody, Tags=tags, Parameters=parameters, Capabilities=['CAPABILITY_IAM']))
except botocore.exceptions.ClientError as e:
    if 'AlreadyExistsException' in str(e):
        try:
            print('STACK UPDATED:', client.update_stack(StackName=stack_name, TemplateBody=templateBody, Tags=tags, Parameters=parameters, Capabilities=['CAPABILITY_IAM']))
        except botocore.exceptions.ClientError as e:
            if 'No updates are to be performed' in str(e):
                print('NO STACK UPDATES REQUIRED')
            else:
                raise
    else:
        raise
