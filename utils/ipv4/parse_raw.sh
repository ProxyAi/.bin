#!/bin/bash

# Read the input file
input_file="ip_raw.txt"

# Initialize an array to hold IPv4 addresses
ipv4_addresses=()

THREAD=false

# Temporary file to store updated IPs
tempfile=$(mktemp)

# Function to perform whois lookup and filter IPs
_filter_by_grep_whois_ip() {
    local ip="$1"
    whois_output=$(whois -a "$ip")

    # Check if the whois output contains certain keywords
    if echo "$whois_output" | grep -iq "Amazon"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "Google"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "GOOG"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "ISPIRIA"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "UK"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "GB"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "O2"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "PLUSNET"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "BT"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "cloudflare"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "CLOUDFLARE"; then
        echo "1"
    elif echo "$whois_output" | grep -iq "VIRGIN-MEDIA"; then
        echo "1"
    else
        echo "$ip"
    fi
}

# Extract IPv4 addresses and load them into the array
while IFS= read -r line; do
    # Use grep to extract the IPv4 addresses from the line
    ipv4=$(echo "$line" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
    if [ -n "$ipv4" ]; then
        ipv4_addresses+=("$ipv4")
    fi
done <"$input_file"

# Remove duplicate IPv4 addresses
unique_ipv4_addresses=($(echo "${ipv4_addresses[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Loop through the array and print each IPv4 address
for ip in "${unique_ipv4_addresses[@]}"; do
    FILTER="$(_filter_by_grep_whois_ip "$ip")"
    echo "FILTER: $ip - ${FILTER}"
    if [[ "$FILTER" != "1" ]]; then
        echo "$ip" >>"$tempfile"
    fi
done

mv "$tempfile" ipv4.txt
