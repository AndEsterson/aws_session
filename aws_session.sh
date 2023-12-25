#!/bin/bash

# Global vars
role_arn="<role_arn>"
profile="default"
serial_number="<mfa_serial_number>"

if [ -z "$PS1" ] ; then
    >&2 echo "This script must be sourced"
    exit
fi

if [[ $1 = "exit" ]]; then
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    export PS1=$PS1_PRE_AWS_SESSION
else
    # Run the AWS CLI command and store the JSON response
    echo -n "mfa token: "
    read token
    aws_output=$(aws sts assume-role --role-arn $role_arn --role-session-name "session-role" --profile $profile --serial-number $serial_number --token-code $token)

    # Parse the JSON response and extract values
    access_key=$(echo $aws_output | jq -r .Credentials.AccessKeyId)
    secret_key=$(echo $aws_output | jq -r .Credentials.SecretAccessKey)
    session_token=$(echo $aws_output | jq -r .Credentials.SessionToken)
    
    if [[ -z $access_key || -z $secret_key || -z $session_token ]]; then
        >&2 echo 'assume-role failed'
    else
            # Export values as environment variables
            export AWS_ACCESS_KEY_ID=$access_key
            export AWS_SECRET_ACCESS_KEY=$secret_key
            export AWS_SESSION_TOKEN=$session_token
            export PS1_PRE_AWS_SESSION=$PS1
            export PS1="%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[yellow]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
    fi
fi
