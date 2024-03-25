# AWS session
this is a very simple (but handy) bash script that prompts for an mfa code, asks for creds for a role that requires mfa, then setsthese. 

Helpful for Terraform/Opentofu, where handling mfa/assumed roles can be a pain.

You can `source ./aws_session.sh <profile>` to enter and then `source ./aws_session.sh exit` to exit, the idea is that you'll probably alias `source /some/path/aws_session.sh` to make your life easier (I use `alias awss=source /some/path/aws_session.sh`). 

The profile argument corresponds to the profile of an mfa enabled assumed role in your aws credentials file. If no argument is supplied, `aws_session.sh` will attempt to assume the default profile.

You can optionally specify a `session_color` in your aws credentials file, e.g `session_color = yellow` this doesn't do anything itself because I don't want to mess up your `$PS1` or `$PROMPT` but `$AWS_SESSION_COLOR` `$AWS_SESSION_EXPIRY` and `AWS_MFA_PROFILE` are defined when script executes, and can be used down the line (e.g I define my `$PROMPT` to show my profile in the corresponding colour, and to remove the session variables after `$AWS_SESSION_EXPIRY`)
