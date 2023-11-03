#!/bin/bash

# Author: admin@xoren.io
# Script: multi-threaded.sh
# Link https://github.com/xorenio
# Description: Script to help multi thread bash scripts.


# Function: process_html_file
# Description: Does something with the given file.
# Parameters:
# - $1 file path
# Returns: None

process_html_file() {
    local file=$1
    echo "do something with ${file}"
}

## SCRIPT SUB RUN TIME
if [[ $# -ge 1 ]]; then
    process_html_file "$1"
    exit
fi

# Function: traverse_and_process
# Description: Finds all html files and process any found.
# Parameters: None
# Returns: None

traverse_and_process() {
    local num_cores joblist;

    # Set to half the amount of available cores
    num_cores=$(($(nproc) / 2))
    joblist=()

    # Loop jobs list
    while IFS= read -r file; do

        # While jobs list is full
        while [[ ${#joblist[@]} -ge ${num_cores} ]]; do

            # Wait for any job to finish
            for job in "${!joblist[@]}"; do
                # If job finished remove from job list
                if ! kill -0 "${joblist[$job]}" 2> /dev/null; then
                    unset "joblist[$job]"
                fi
            done

            # if no slots are available, sleep for a while
            if [[ ${#joblist[@]} -ge ${num_cores} ]]; then
                sleep 0.04
            fi
        done

        # start a new job
        bash "$0" "${file}" &

        # Add process to job list
        joblist+=("$!")

    done < <(find "$HOME/" -type f -name "*.html")

    # wait for any remaining jobs
    for job in "${joblist[@]}"; do
        wait "${job}"
    done
}

## SCRIPT MAIN RUN TIME
traverse_and_process