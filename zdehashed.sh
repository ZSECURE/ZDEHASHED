#!/bin/bash

# Setting Variables
APIKey="email_address:api_key"
SearchDomain=$1
SaveLocation=$2

#Creating function
function dehashed {

        curl --silent "https://api.dehashed.com/search?query=domain:$SearchDomain" -u $APIKey  -H 'Accept: application/json' -o $SaveLocation

        }

dehashed
