#!/bin/bash

# Author: admin@xoren.io
# Script: memchart.sh
# Link https://github.com/xorenio
# Description: Process bar for memory usage with highest recorded.

# Initialize the highest memory usage variable
highest_memory_usage=0

# Function to print a simple bar chart
print_chart() {
    local usage=$1
    local total_bars=50

    local filled_bars=$(awk "BEGIN {printf(\"%0.f\", $usage * $total_bars)}")
    local empty_bars=$((total_bars - filled_bars))

    printf "|"
    for i in $(seq 1 $filled_bars); do
        printf "#"
    done

    for i in $(seq 1 $empty_bars); do
        printf " "
    done
    printf "| %s%%\n" "$(awk "BEGIN {printf(\"%0.2f\", $usage * 100)}")"
}

# Clear the screen
clear

# Get the script's memory usage in MB
script_memory_usage=$(ps -o rss= -p $$ | awk '{print $1 / 1024}')

# Run the loop indefinitely, updating the chart every 0.5 seconds
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
    if [ $(echo "$adjusted_used_memory > $highest_memory_usage" | bc -l) -eq 1 ]; then
        highest_memory_usage=$adjusted_used_memory
    fi

    #if [ $(echo "ifelse($adjusted_used_memory > $highest_memory_usage, 1, 0)" | bc -l) -eq 1 ]; then
    #    highest_memory_usage=$adjusted_used_memory
    #fi

    # Print the chart and the highest memory usage
    echo "Memory Usage:"
    print_chart $usage_percentage
    echo "Highest Memory Usage: ${highest_memory_usage} MB"

    # Move the cursor back to the beginning of the chart
    tput cuu 3

    # Wait for 0.5 seconds
    sleep 0.5
done
