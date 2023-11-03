#!/bin/bash

# Author: admin@xoren.io
# Script: mem.sh
# Link https://github.com/xorenio
# Description: Displays memory usage percentage.

# Get the total memory and used memory in kilobytes
mem_info=$(free -k | grep Mem)
total_mem=$(echo $mem_info | awk '{print $2}')
used_mem=$(echo $mem_info | awk '{print $3}')

# Convert the used memory to a percentage number out of 100
mem_usage_percentage=$(echo "scale=2; $used_mem/$total_mem*100" | bc)

# Output the memory usage as a percentage number out of 100
echo "Memory usage: $mem_usage_percentage%"
