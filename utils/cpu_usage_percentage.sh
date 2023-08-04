#!/bin/bash

# Author: admin@xoren.io
# Script: cpu_usage_percentage.sh
# Link https://github.com/xorenio
# Description: Script to display cpu usage in a percentage.

# Get the CPU usage as a decimal number
cpu_usage=$(top -bn1 | awk '/Cpu\(s\):/ {print $2}')

# Convert the CPU usage to a percentage number out of 100
cpu_usage_percentage=$(echo "scale=2; $cpu_usage/1" | bc)

# Output the CPU usage as a percentage number out of 100
echo "CPU usage: $cpu_usage_percentage%"
