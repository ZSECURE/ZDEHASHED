#!/bin/bash

#Usage
if [ $# -eq 0 ]; then
    echo "Usage: ./zdehashed-parser.sh <command> <save_location>"
    echo "Commands: emails, passwords, combo"
    echo "         emails: this extracts all the email addresses"
    echo "         passwords: this extracts all the passwords"
    echo "         combo: this extracts all the email addresses and passwords"
    exit 1
fi

#Setting Variables
cmd_function=$1
Filename=$2
SaveLocation=${Filename%%.*}

#extract email addresses
function extract_emails {

        jq '.entries[] | .email' $Filename -r > $SaveLocation-extracted-emails.txt
}

#extract passwords
function extract_passwords {

        jq '.entries[] | .password' $Filename -r > $SaveLocation-extracted-passwords.txt
}


#extract email + password combinations
function extract_emailpasscombo {

        jq '.entries[] | .email,.password' $Filename -r > $SaveLocation-extracted-emails-passwords-combo.txt
}

if [ $cmd_function == "emails" ]; then
    extract_emails
elif [ $cmd_function == "passwords" ]; then
    extract_passwords
elif [ $cmd_function == "combo" ]; then
    extract_emailpasscombo
fi
