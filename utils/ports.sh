#!/bin/bash

# Author: admin@xoren.io
# Script: ports.sh
# Link https://github.com/xorenio
# Description: Jsonify netstat with extra docker.

# Run netstat command to get port usage information and filter the output
netstat_output=$(netstat -tulnpe | awk 'NR>2')

# Create an array to store JSON objects
json_string="["


line_index=0

# Loop through each line of the netstat output
while IFS= read -r line; do
    if [[ $line_index -gt 0 ]]; then
        json_string+=","
    fi

    fields=($(echo "$line" | awk '{split($4,a,":"); split($5,b,":"); print $1, $4, a[2], $5, b[2], $7, $7, $NF}'))

    # Extract the relevant fields using awk
    protocol="${fields[0]}"
    local_address="${fields[1]}"
    local_port="${fields[2]}"
    foreign_address="${fields[3]}"
    foreign_port="${fields[4]}"

    foreign_port=$(echo "$line" | awk '{split($5,a,":"); print a[2]}')

    user_uid=$(echo "$line" | awk '{print $7}' | awk -F "/" '{print $1}')

    user_name=$(getent passwd "$user_uid" | cut -d ':' -f 1)


    program=$(echo "$line" | awk '{print $NF}')

    # Create a JSON string using the extracted fields
    json_string+="{"
    json_string+="\"protocol\":\"$protocol\","
    json_string+="\"local_address\":\"$local_address\","
    json_string+="\"local_port\":\"$local_port\","
    json_string+="\"foreign_address\":\"$foreign_address\","
    json_string+="\"foreign_port\":\"$foreign_port\","
    json_string+="\"user\":{\"UID\":\"$user_uid\", \"name\":\"$user_name\"},"


    if echo $program | grep "docker" > /dev/null; then

        container_id=$(docker ps --format "table {{.ID}}\t{{.Ports}}" | grep "${local_address}" | awk 'NR==1' | awk '{printf "%s", $1}')

        if ! [[ $container_id =~ ^[0-9a-f]{12}$ ]]; then
            container_id=$(docker ps --format "table {{.ID}}\t{{.Ports}}" | grep "${local_port}" | awk 'NR==1' | awk '{printf "%s", $1}')
        fi


        if [[ $container_id =~ ^[0-9a-f]{12}$ ]]; then

            # docker_data=$(docker inspect "$container_id")

            container_name=$(docker ps --format "table {{.ID}}\t{{.Names}}" | grep "$container_id" | awk '{printf "%s", $2}')
            container_image=$(docker ps --format "table {{.ID}}\t{{.Image}}" | grep "$container_id" | awk '{printf "%s", $2}')
            container_command=$(docker ps --format "table {{.ID}}\t{{.Command}}" | grep "$container_id" | awk '{print substr($0, index($0,$2))}' | tr -d '"')
            container_status=$(docker ps --format "table {{.ID}}\t{{.Status}}" | grep "$container_id" | awk '{print substr($0, index($0,$2))}' | tr -d '"')
            container_ports=$(docker ps --format "table {{.ID}}\t{{.Ports}}" | grep "$container_id" | awk '{printf "%s", $2}')

            docker_string="{"
            docker_string+="\"id\":\"$container_id\","
            docker_string+="\"name\":\"$container_name\","
            docker_string+="\"image\":\"$container_image\","
            docker_string+="\"command\":\"$container_command\","
            docker_string+="\"uptime\":\"$container_status\" "
            docker_string+="\"ports\":\"$container_ports\","
            docker_string+="}"

            json_string+="\"docker\": $docker_string,"

        fi
    fi

    json_string+="\"program\":\"$program\""

    json_string+="}"

    # Increment the index counter
    ((line_index++))
done <<< "$netstat_output"

json_string+="]"

# Write the JSON array to a file
output_file="port_usage.json"
echo "$json_string" > "$output_file"

echo "Port usage JSON file generated: $output_file"

exit
