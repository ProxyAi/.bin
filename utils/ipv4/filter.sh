#!/bin/bash

THREAD=false

# Read IP addresses from ipv4.txt into an array
mapfile -t ips <ipv4.txt

# Temporary file to store updated IPs
tempfile=$(mktemp)

# Function to perform whois lookup and filter IPs
perform_whois() {
    ip=$1
    echo "Performing whois lookup for IP: $ip"
    whois_output=$(whois -a "$ip")

    # Check if the whois output contains certain keywords
    if echo "$whois_output" | grep -iq "Amazon"; then
        echo "Amazon: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "Google"; then
        echo "Google: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "ISPIRIA"; then
        echo "ISPIRIA: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "UK"; then
        echo "UK: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "GB"; then
        echo "GB: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "O2"; then
        echo "O2: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "PLUSNET"; then
        echo "PLUSNET: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "BT"; then
        echo "BT: $ip. Removing from list."
    elif echo "$whois_output" | grep -iq "GOOG"; then
        echo "GOOG: $ip. Removing from list."
    else
        # If not Cloudflare, write the IP to the temporary file
        echo "$ip" >>"$tempfile"
    fi

    echo "--------------------------------------------"
}

if [[ "$THREAD" = "true" ]]; then

    export tempfile

    # Export the perform_whois function for use by parallel
    export -f perform_whois

    # Use parallel to run whois lookups in parallel
    printf "%s\n" "${ips[@]}" | parallel -j 8 perform_whois {}
else
    # Loop through each IP and perform a whois lookup
    for ip in "${ips[@]}"; do
        # perform_whois "$ip"
        whois_output=$(whois -a "$ip")

        # Check if the whois output contains "cloudflare"
        if echo "$whois_output" | grep -iq "Amazon"; then
            echo "Amazon: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "Google"; then
            echo "Google: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "ISPIRIA"; then
            echo "ISPIRIA: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "UK"; then
            echo "UK: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "GB"; then
            echo "GB: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "O2"; then
            echo "O2: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "PLUSNET"; then
            echo "PLUSNET: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "BT"; then
            echo "BT: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "cloudflare"; then
            echo "cloudflare: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "CLOUDFLARE"; then
            echo "CLOUDFLARE: $ip. Removing from list."
        elif echo "$whois_output" | grep -iq "GOOG"; then
            echo "GOOG: $ip. Removing from list."
        else
            # If not Cloudflare, write the IP to the temporary file
            echo "$ip" >>"$tempfile"
        fi
    done
fi

# Replace original ipv4.txt with the updated IPs
mv "$tempfile" ipv4.txt
