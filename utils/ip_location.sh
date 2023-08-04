#!/bin/bash

# Author: admin@xoren.io
# Script: ip_location.sh
# Link https://github.com/xorenio
# Description: Gets location from whois record. whois isnt live

function valid_ip()
{
    local  ip=$1
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}



ip=$(curl -s -X GET https://checkip.amazonaws.com)

if valid_ip ${ip}; then
 sleep 1;
 # echo "IP: ${ip}"
else
  exit 1;
fi

ISOLOCATION=$(whois $ip | grep -iE ^country:)
ISOLOCATION=$( echo $ISOLOCATION | head -n 1 )
ISOLOCATION=${ISOLOCATION:(-2)}

echo "LOCAL_FIRST: "$LOCAL_FIRST;
## GET LOCATION FROM SERVICE
# LOCATION=$(curl https://ipvigilante.com/ $ip)

