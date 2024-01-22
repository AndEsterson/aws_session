#!/bin/bash


if [[ -z "$PS1" ]]; then
    >&2 echo "This script must be sourced"
    exit
fi

if [[ $1 = "exit" ]]; then
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    if [[ -n "PS1_PRE_AWS_SESSION" ]]; then
        export PS1=$PS1_PRE_AWS_SESSION
    fi
else
    if [[ -z "$1" ]]; then
        profile="default"
    else
        profile="$1"
    fi
    role_arn="$(aws configure get $profile.role_arn)"
    source_profile="$(aws configure get $profile.source_profile)"
    serial_number="$(aws configure get $profile.mfa_serial)"
    session_color="$(aws configure get $profile.session_color)"
    if [[ -z $role_arn || -z $source_profile || -z $serial_number ]]; then
        >&2 echo 'the profile for the role being assumed must have a role_arn, source_profile, serial number'
    else
        echo -n "mfa token: "
        read token
        aws_output=$(aws sts assume-role --role-arn $role_arn --role-session-name "session-role" --profile $source_profile --serial-number $serial_number --token-code $token)

        access_key=$(echo $aws_output | jq -r .Credentials.AccessKeyId)
        secret_key=$(echo $aws_output | jq -r .Credentials.SecretAccessKey)
        session_token=$(echo $aws_output | jq -r .Credentials.SessionToken)
    fi 
    if [[ -z $access_key || -z $secret_key || -z $session_token ]]; then
        >&2 echo 'assume-role failed'
    else
            export AWS_ACCESS_KEY_ID=$access_key
            export AWS_SECRET_ACCESS_KEY=$secret_key
            export AWS_SESSION_TOKEN=$session_token
            if [[ -n "$session_color" ]]; then
                if [[ -z "PS1_PRE_AWS_SESSION" ]]; then
                    export PS1_PRE_AWS_SESSION=$PS1
                fi
                export PS1="%{$fg[$session_color]%}%n%{$reset_color%}@%{$fg[$session_color]%}%m %{$fg[$session_color]%}%~ %{$reset_color%}%% "
            fi
    fi
fi
