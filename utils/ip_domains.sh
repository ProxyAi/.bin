#!/bin/bash

# Author: admin@xoren.io
# Script: ip_domain.sh
# Link https://github.com/xorenio
# Description: Get domains from given ip.

ip_address=$(curl -sf http://ipv4.icanhazip.com/)  # Replace with the desired IP address

# Retrieve the list of domains pointing to the IP address
#domains=$(dig +short -x "$ip_address" | sed 's/\.$//')
domains=$(host "$ip_address" | awk '{print $NF}' | sed 's/.$//')

# Iterate through each domain and retrieve its corresponding IP address(es)
for domain in $domains; do
  #ip_addresses=$(dig +short "$domain")
  ip_addresses=$(host "$domain" | awk '/has address/ {print $NF}')
  echo "Domain: $domain"
  echo "IP Address(es): $ip_addresses"
  echo
done
