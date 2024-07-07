#!/bin/bash

# Usage function
function usage {
    echo "Usage: ./zdehashed-parser.sh <command> <save_location> <output_mode> [report_mode]"
    echo "Commands: emails, passwords, combo, combo_sorted, combo_raw, hashes, combo_hashes"
    echo "         emails: this extracts all the email addresses"
    echo "         passwords: this extracts all the passwords"
    echo "         combo: this extracts all the email addresses and passwords"
    echo "         combo_sorted: this extracts and sorts unique email and password combinations"
    echo "         combo_raw: this extracts raw email and password combinations"
    echo "         hashes: this extracts all the hashed passwords"
    echo "         combo_hashes: this extracts all the email addresses, passwords, and hashed passwords"
    echo "Output modes: print, save"
    echo "         print: this prints the output to the console"
    echo "         save: this saves the output to a file"
    echo "Report mode (optional): pretty"
    echo "         pretty: this formats the combo_hashes output for a pentesting report"
    exit 1
}

#Setting Variables
cmd_function="$1"
Filename="$2"
output_mode="$3"
report_mode="$4"
SaveLocation="${Filename%%.*}"

# Exit if not present
if [ -z "$cmd_function" ] || [ -z "$Filename" ] || [ -z "$output_mode" ]; then
    usage
fi

#extract email addresses
function extract_emails {
    if [ "$output_mode" == "print" ]; then
        jq '.entries[] | .email' "$Filename" -r
    else
        jq '.entries[] | .email' "$Filename" -r > "$SaveLocation-extracted-emails.txt"
    fi
}

#extract passwords
function extract_passwords {
    if [ "$output_mode" == "print" ]; then
        jq '.entries[] | .password' "$Filename" -r
    else
        jq '.entries[] | .password' "$Filename" -r > "$SaveLocation-extracted-passwords.txt"
    fi
}

#extract email + password combinations
function extract_emailpasscombo {
    if [ "$output_mode" == "print" ]; then
        jq '.entries[] | .email,.password' "$Filename" -r
    else
        jq '.entries[] | .email,.password' "$Filename" -r > "$SaveLocation-extracted-emails-passwords-combo.txt"
    fi
}

#extract and sort unique email + password combinations
function extract_emailpasscombo_sorted {
    if [ "$output_mode" == "print" ]; then
        jq -r '.entries[] | "\(.email):\(.password)"' "$Filename" | sort -u | grep -Eov ':$'
    else
        jq -r '.entries[] | "\(.email):\(.password)"' "$Filename" | sort -u | grep -Eov ':$' > "$SaveLocation-extracted-emails-passwords-combo-sorted.txt"
    fi
}

#extract raw email + password combinations
function extract_emailpasscombo_raw {
    if [ "$output_mode" == "print" ]; then
        jq -r '.entries[] | "\(.email):\(.password)"' "$Filename"
    else
        jq -r '.entries[] | "\(.email):\(.password)"' "$Filename" > "$SaveLocation-extracted-emails-passwords-combo-raw.txt"
    fi
}

#extract hashed passwords
function extract_hashes {
    if [ "$output_mode" == "print" ]; then
        jq '.entries[] | .hashed_password' "$Filename" -r
    else
        jq '.entries[] | .hashed_password' "$Filename" -r > "$SaveLocation-extracted-hashes.txt"
    fi
}

#extract email + password + hashed password combinations
function extract_emailpasshashescombo {
    if [ "$output_mode" == "print" ]; then
        jq '.entries[] | .email,.password,.hashed_password' "$Filename" -r
    else
        jq '.entries[] | .email,.password,.hashed_password' "$Filename" -r > "$SaveLocation-extracted-emails-passwords-hashes-combo.txt"
    fi
}

#extract and pretty print email + password + hashed password combinations with unique counts
function extract_emailpasshashescombo_pretty {
    email_password_hashes=$(jq -r '.entries[] | [.email, .password, .hashed_password] | @tsv' "$Filename")
    unique_emails=$(echo "$email_password_hashes" | cut -f1 | sort -u | wc -l)
    unique_passwords=$(echo "$email_password_hashes" | cut -f2 | sort -u | wc -l)
    
    if [ "$output_mode" == "print" ]; then
        echo "Unique Email Addresses: $unique_emails"
        echo "Unique Passwords: $unique_passwords"
        echo ""
        echo -e "Email\tPassword\tHashed Password"
        echo "$email_password_hashes" | column -t
    else
        {
            echo "Unique Email Addresses: $unique_emails"
            echo "Unique Passwords: $unique_passwords"
            echo ""
            echo -e "Email\tPassword\tHashed Password"
            echo "$email_password_hashes" | column -t
        } > "$SaveLocation-extracted-emails-passwords-hashes-combo-pretty.txt"
    fi
}

if [ "$cmd_function" == "emails" ]; then
    extract_emails
elif [ "$cmd_function" == "passwords" ]; then
    extract_passwords
elif [ "$cmd_function" == "combo" ]; then
    extract_emailpasscombo
elif [ "$cmd_function" == "combo_sorted" ]; then
    extract_emailpasscombo_sorted
elif [ "$cmd_function" == "combo_raw" ]; then
    extract_emailpasscombo_raw
elif [ "$cmd_function" == "hashes" ]; then
    extract_hashes
elif [ "$cmd_function" == "combo_hashes" ]; then
    if [ "$report_mode" == "pretty" ]; then
        extract_emailpasshashescombo_pretty
    else
        extract_emailpasshashescombo
    fi
else
    usage
fi
