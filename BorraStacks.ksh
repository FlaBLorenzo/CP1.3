#!/bin/bash

LIS=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query 'StackSummaries[0].StackName' | sed -e 's/"//g')
echo $LIS
aws cloudformation delete-stack --stack-name ${LIS} 

LISF=$(aws cloudformation list-stacks --stack-status-filter DELETE_FAILED --query 'StackSummaries[0].StackName' | sed -e 's/"//g')
echo $LISF
aws cloudformation delete-stack --stack-name ${LISF} --deletion-mode FORCE_DELETE_STACK
