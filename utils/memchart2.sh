#!/bin/bash

# BROKEN

# Author: admin@xoren.io
# Script: memchart2.sh
# Link https://github.com/xorenio
# Description: Process bar for memory usage with highest recorded.

# Function to print a simple gauge
print_gauge() {
    local usage=$1
    local percentage=$(awk "BEGIN {printf(\"%0.f\", $usage * 100)}")
    dialog --title "Memory Usage" --gauge "Highest Memory Usage: ${highest_memory_usage} MB\n\nPress 'q' to quit" 10 60 $percentage
}

# Initialize the highest memory usage variable
highest_memory_usage=0

# Set up a trap to handle the 'q' keypress
trap "stty $(stty -g); clear; exit" SIGINT SIGTERM

# Configure the terminal to react immediately to keypresses
stty -echo -icanon time 0 min 0

# Get the script's memory usage in MB
script_memory_usage=$(ps -o rss= -p $$ | awk '{print $1 / 1024}')

# Run the loop indefinitely, updating the gauge every 0.5 seconds
while true; do
    # Get memory usage data
    memory_data=$(free -m | grep Mem)

    # Calculate usage percentage
    total_memory=$(echo $memory_data | awk '{print $2}')
    used_memory=$(echo $memory_data | awk '{print $3}')

    # Subtract the script's memory usage
    adjusted_used_memory=$(awk "BEGIN {print $used_memory - $script_memory_usage}")

    usage_percentage=$(awk "BEGIN {printf(\"%.2f\", $adjusted_used_memory / $total_memory)}")

    # Update the highest memory usage if necessary
    if [ $(echo "ifelse($adjusted_used_memory > $highest_memory_usage, 1, 0)" | bc -l) -eq 1 ]; then
        highest_memory_usage=$adjusted_used_memory
    fi

    # Print the gauge and the highest memory usage
    print_gauge $usage_percentage

    # Check for 'q' keypress
    read -n 1 -t 0.5 key
    if [[ $key == "q" ]]; then
        stty $(stty -g)  # Reset terminal settings
        clear
        exit
    fi
done

