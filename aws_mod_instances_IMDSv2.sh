#!/bin/bash

# Taking user inputs and assigning them to environment variables
read -p 'AWS Region: ' AWS_REGION
read -sp 'AWS Access key: ' AWS_ACCESS_KEY_ID
echo ""
read -sp 'AWS Secret key: ' AWS_SECRET_ACCESS_KEY
echo ""

#Setting up AWS environment variables
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${AWS_REGION}"

# Create an empty instance_ids.txt
> instance_ids.txt

# Fetching all instances ID and saving to variable
echo "Fetching instance details..."
instances=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --output text  --region "${AWS_REGION}")

echo "Checking instances for IMDSv2..."
for instance in $instances; do
    http_tokens=$(aws ec2 describe-instances --instance-ids "${instance}" --query 'Reservations[*].Instances[*].MetadataOptions.HttpTokens' --output text  --region "${AWS_REGION}")
    if [[ "${http_tokens}" == "optional" ]]; then
      echo "Found: ${instance}"
      echo "${instance}" >> instance_ids.txt
    fi
done

# Check if the file is empty and if so, exit the script
if [[ ! -s instance_ids.txt ]]; then
    echo "No instances where IMDSv2 is optional found. Exiting..."
    rm instance_ids.txt
    exit 1
fi

echo "Modifying IMDSv2 settings for instances..."
while read -r line; do
    aws ec2 modify-instance-metadata-options --instance-id "${line}" --http-tokens required --http-endpoint enabled --region "${AWS_REGION}"
done < instance_ids.txt

# Cleaning up
rm instance_ids.txt