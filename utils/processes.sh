#!/bin/bash

# Author: admin@xoren.io
# Script: processes.sh
# Link https://github.com/xorenio
# Description: Script to monitor process changes.

# Get the list of processes at the start of the script
old_processes=$(ps -eo pid,comm --no-headers)

# Wait for 30 seconds
sleep 30

# Get the list of processes after 30 seconds
new_processes=$(ps -eo pid,comm --no-headers)

# Compare the old and new process lists to find the differences
diff <(echo "$old_processes") <(echo "$new_processes") | grep '[<>]' > /dev/null

# If there are differences, report them
if [[ $? -eq 0 ]]; then
    echo "Process changes detected:"
    diff <(echo "$old_processes") <(echo "$new_processes") | grep '[<>]'
fi
