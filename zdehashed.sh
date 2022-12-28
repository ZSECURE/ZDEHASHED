#!/bin/bash

# Usage function
function usage {
    echo "Usage: dehashed <search_domain> <save_location>"
    echo "Example: dehashed example.com results.json"
    exit 1
}

# Exit if not present
if [ -z "$SearchDomain" ] || [ -z "$SaveLocation" ]
then
    usage
fi

# Setting Variables
APIKey="email_address:api_key"
SearchDomain=$1
SaveLocation=$2

#Creating function
function dehashed {

        curl --silent "https://api.dehashed.com/search?query=domain:$SearchDomain" -u $APIKey  -H 'Accept: application/json' -o $SaveLocation

        }

dehashed
