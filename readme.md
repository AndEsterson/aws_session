# AWS session
this is a very simple (but handy) bash script that prompts for an mfa code, asks for creds for a role that requires mfa, then setsthese. 

Helpful for Terraform/Opentofu, where handling mfa/assumed roles can be a pain.

You can `source ./aws_session.sh` to enter and then `source ./aws_session.sh exit` to exit, the idea is that you'll probably alias `source /some/path/aws_session.sh` to make your life easier (I use `alias awss=source /some/path/aws_session.sh`). 

Currently this script requires manually adding some variables, hopefully I'll get round to improving that

# TO DO
make this read from aws credentials and take multiple possible accounts, instead of needing creds manaully added
