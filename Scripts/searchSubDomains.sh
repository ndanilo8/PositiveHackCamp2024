#!/bin/bash

#Author: Danilo Nascimento

# Ensure the script is executed with two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <domain> <record_type>"
    exit 1
fi

# Assign arguments to variables
DOMAIN=$1
RECORD_TYPE=$2

# Fetch subdomains from various sources and store them in an array
subdomains=()

# crt.sh
crt_subdomains=$(curl -s "https://crt.sh/?q=${DOMAIN}&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u)
subdomains+=($crt_subdomains)

# Amass
amass_subdomains=$(amass enum -d $DOMAIN)
subdomains+=($amass_subdomains)

# Subfinder
subfinder_subdomains=$(subfinder -d $DOMAIN)
subdomains+=($subfinder_subdomains)

# Remove duplicate subdomains
subdomains=($(echo "${subdomains[@]}" | tr ' ' '\n' | sort -u))

# Cut the subdomain part and perform DNS queries
for sub in "${subdomains[@]}"; do
    sub_cut=$(echo "$sub" | cut -d'.' -f1)
    dig $RECORD_TYPE $sub_cut.$DOMAIN | tee -a dig_results.txt
done
