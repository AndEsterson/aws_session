# AWS session
this is a very simple (but handy) bash script that prompts for an mfa code, asks for creds for a role that requires mfa, then setsthese. 

Helpful for Terraform/Opentofu, where handling mfa/assumed roles can be a pain.

You can `source ./aws_session.sh <profile>` to enter and then `source ./aws_session.sh exit` to exit, the idea is that you'll probably alias `source /some/path/aws_session.sh` to make your life easier (I use `alias awss=source /some/path/aws_session.sh`). 

The profile argument corresponds to a profile in your aws credentials file, it must specify the role_arn, source_profile and mfa_serial (but probably doesn't need anything else). If no argument is supplied, it will attempt to assume the default profile (i.e `call aws configure get` without a profile specified).

You can optionally specify a `session_color` in your aws credentials file, e.g `session_color = yellow` this will be used to update `$PS1` until you exit the session, helping to track which profile is in use (you probably want to avoid this if you are doing anything fancy with shell prompts e.g [starship](https://github.com/starship/starship)).
