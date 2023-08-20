<#
.SYNOPSIS
This script searches the Dehashed API for passwords associated with a given domain.

.DESCRIPTION
This script demonstrates how to use the Dehashed API to search for passwords associated with a specific domain. It retrieves the passwords and outputs them to the console.

.PARAMETER search_domain
The domain to search for passwords.

.PARAMETER save_location
The location to save the results.

.EXAMPLE
PS> zDehashed.ps1 example.com results.json
Searches the Dehashed API for passwords associated with the domain "example.com" and saves the results to "results.json".

.NOTES
- You need a valid Dehashed API key to use this script.
- The API key should be provided in the format "email:api_token".
#>

 # Usage function
function usage {
    Write-Host "Usage: zDehashed.ps1 <search_domain> <save_location>"
    Write-Host "Example: zDehashed.ps1 example.com results.json"
    exit 1
}

# Setting Variables
$APIKey = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("change@me.com:apitoken_goes_here"))
$SearchDomain = $args[0]
$SaveLocation = $args[1]

# Exit if not present
if ([string]::IsNullOrEmpty($SearchDomain) -or [string]::IsNullOrEmpty($SaveLocation)) {
    usage
}

# Creating function
function dehashed {
    $response = Invoke-RestMethod -Uri "https://api.dehashed.com/search?query=domain:$SearchDomain" -Method Get -Headers @{
        "Authorization" = "Basic $APIKey"
        "Accept" = "application/json"
    }

    # Check if the response is successful
    if ($response.success -eq $true) {
        # Extract passwords from the response
        $passwords = $response.entries | Where-Object { $_.password -ne $null } | Select-Object -ExpandProperty password

        # Remove blank lines
        $passwords = $passwords | Where-Object { $_ -ne '' }

        # Sort passwords alphabetically
        $passwords = $passwords | Sort-Object

        # Remove duplicates
        $passwords = $passwords | Get-Unique

        # Output the passwords
        $balance = $response.balance
        Write-Host "`nBalance: " $balance
        Write-Host "--------------------------"`n
        Write-Host "Passwords:"
        Write-Host "--------------------------"
        $passwords
    } else {
        Write-Host "API request failed: $($response.message)"
    }
}

dehashed
 
