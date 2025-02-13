#!/bin/bash

LIS=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query 'StackSummaries[0].StackName' | sed -e 's/"//g')
echo $LIS

aws cloudformation delete-stack --stack-name ${LIS} --deletion-mode FORCE_DELETE_STACK
