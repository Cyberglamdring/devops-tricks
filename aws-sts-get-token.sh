#!/bin/bash
## HOW TO RUN & CREATE ALIAS
# chmod +x aws-sts-get-token.sh
# alias awslogin="$HOME/aws-sts-get-token.sh"

read -p 'Profile (default): ' AWS_USER_PROFILE
read -p 'MFA ARN (default arn:aws:iam::<aws_account_id>:mfa/<user>): ' ARN_OF_MFA
read -p 'MFA Token (xxxxxx): ' MFA_TOKEN_CODE

read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< \
$( aws --profile $AWS_USER_PROFILE sts get-session-token \
  --serial-number $ARN_OF_MFA \
  --token-code $MFA_TOKEN_CODE \
  --output text  | awk '{ print $2, $4, $5 }')

if [ -z $AWS_ACCESS_KEY_ID ]
then
  echo "Failed to get Session token!"

else
  `aws --profile $AWS_USER_PROFILE configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"`
  `aws --profile $AWS_USER_PROFILE configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"`
  `aws --profile $AWS_USER_PROFILE configure set aws_session_token "$AWS_SESSION_TOKEN"`
   
  echo "Session token obtained!"
fi
