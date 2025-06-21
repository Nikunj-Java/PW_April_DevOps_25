#!/bin/bash
#String
input="full_name=nikunj soni;email=nikunj.soni@example.com;city=ahmedabad"

# Split the string by ';'
IFS=';' read -ra fields <<< "$input"

# Initialize variables
full_name=""
email=""
city=""

# Extract values
for field in "${fields[@]}"; do
    key="${field%%=*}"
    value="${field#*=}"
    case $key in
        full_name) full_name="${value^^}" ;;         # Uppercase full name
        email) email="$value" ;;
        city) city="${value^}" ;;                    # Capitalize city
    esac
done

# Extract username from email
username="${email%@*}"

# Output formatted result
echo "NAME      : $full_name"
echo "USERNAME  : $username"
echo "CITY      : $city"
