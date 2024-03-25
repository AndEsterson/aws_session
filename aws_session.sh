#!/bin/bash

_() {
  if [[ -z "$PROMPT" ]]; then
      >&2 echo "This script must be sourced"
      exit
  fi

  if [[ $1 = "exit" ]]; then
      unset AWS_ACCESS_KEY_ID
      unset AWS_SECRET_ACCESS_KEY
      unset AWS_SESSION_TOKEN
      unset AWS_MFA_PROFILE
      unset AWS_SESSION_COLOR
      unset PROMPT_PRE_AWS_SESSION
  else
      if [[ -z "$1" ]]; then
          local mfa_profile="default"
      else
          local mfa_profile="$1"
      fi
      local role_arn="$(aws configure get $mfa_profile.role_arn)"
      local source_profile="$(aws configure get $mfa_profile.source_profile)"
      local serial_number="$(aws configure get $mfa_profile.mfa_serial)"
      local session_color="$(aws configure get $mfa_profile.session_color)"
      if [[ -z $role_arn || -z $source_profile || -z $serial_number ]]; then
          >&2 echo 'the profile for the role being assumed must have a role_arn, source_profile, serial number'
      else
          echo -n "mfa token: "
          read token
          local aws_output=$(aws sts assume-role --role-arn $role_arn --role-session-name "session-role" --profile $source_profile --serial-number $serial_number --token-code $token)
          local expiration_datetime=$(echo $aws_output | jq -r .Credentials.Expiration)
          local access_key=$(echo $aws_output | jq -r .Credentials.AccessKeyId)
          local secret_key=$(echo $aws_output | jq -r .Credentials.SecretAccessKey)
          local session_token=$(echo $aws_output | jq -r .Credentials.SessionToken)
      fi 
      if [[ -z $access_key || -z $secret_key || -z $session_token ]]; then
          >&2 echo 'assume-role failed'
      else
              export AWS_SESSION_COLOR=$session_color
              export AWS_MFA_PROFILE=$mfa_profile
              export AWS_ACCESS_KEY_ID=$access_key
              export AWS_SECRET_ACCESS_KEY=$secret_key
              export AWS_SESSION_TOKEN=$session_token
              export AWS_SESSION_EXPIRY=$(date -d $expiration_datetime +%s)
      fi
  fi
}

_ "$@"
unfunction _
