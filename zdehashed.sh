#!/bin/bash

# Usage function
function usage {
    echo "Usage: dehashed <search_domain>"
    echo "Example: dehashed example.com"
    exit 1
}

# Setting Variables
APIKey="API_Key_Goes_Here"
SearchDomain=$1

# Exit if not present
if [ -z "$SearchDomain" ]
then
    usage
fi

# Function to create directory and save location
function create_save_location {
    local domain_dir=$(echo $SearchDomain | tr '.' '-')
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local save_dir="/opt/zdehashed/domains/$domain_dir"
    local save_location="$save_dir/results-$timestamp.json"

    mkdir -p $save_dir

    echo $save_location
}


#Creating function
function dehashed {
        local save_location=$(create_save_location)

        curl --silent "https://api.dehashed.com/search?query=domain:$SearchDomain" -u $APIKey  -H 'Accept: application/json' -o $save_location

        }

dehashed
