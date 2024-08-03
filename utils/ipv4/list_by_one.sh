#!/bin/bash

# Read IP addresses from ipv4.txt into an array
mapfile -t ips <ipv4.txt

# Loop through each IP and perform a whois lookup
for ip in "${ips[@]}"; do
    echo "Performing whois lookup for IP: $ip"
    whois_output=$(whois "$ip")

    netname=$(echo "$whois_output" | grep -i 'netname' | head -n 1 | awk '{print $2}')
    country=$(echo "$whois_output" | grep -i 'country' | awk '{print $2}')
    inetnum=$(echo "$whois_output" | grep -i 'inetnum' | head -n 1 | awk '{print $2}')
    route=$(echo "$whois_output" | grep -i 'route' | awk '{print $2}')
    descr=$(echo "$whois_output" | grep -i 'descr' | head -n 1 | awk '{print $2}')
    role=$(echo "$whois_output" | grep -i 'role' | head -n 1 | awk '{print $2}')
    created=$(echo "$whois_output" | grep -i 'created' | head -n 1 | awk '{print $2}')
    address=$(echo "$whois_output" | grep -i 'created' | awk '{print $2}')

    echo "netname: $netname"
    echo "country: $country"
    echo "inetnum: $inetnum"
    echo "route: $route"
    echo "descr: $descr"
    echo "created: $created"
    echo "address: $address"

    echo "--------------------------------------------"
    read -n 1 -s -r -p "Press any key to continue"
    echo
done
