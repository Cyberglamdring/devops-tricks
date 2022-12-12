#!/bin/bash
## HOW TO RUN & CREATE ALIAS
# chmod +x aws-sts-get-token.sh
# alias awstoken="$HOME/aws-sts-get-token-v2.sh"
AWS_USER=
AWS_ACCOUNT_ID=
AWS_USER_ARN=arn:aws:iam::AWS_ACCOUNT_ID:mfa/USER

read -p 'Profile (default): ' AWS_USER_PROFILE
read -p 'MFA Token (xxxxxx): ' MFA_TOKEN_CODE

read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< \
$( aws --profile $AWS_USER_PROFILE sts get-session-token \
  --serial-number $AWS_USER_ARN \
  --token-code $MFA_TOKEN_CODE \
  --output text  | awk '{ print $2, $4, $5 }')
  
echo =============================================================
echo export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
echo export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
echo export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
echo =============================================================
