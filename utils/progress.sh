#!/bin/bash

# Author: admin@xoren.io
# Script: progress.sh
# Link https://github.com/xorenio
# Description: Basic script for a progress bar.

# Define the number of iterations
iterations=100

# Get the width of the terminal
termwidth=$(tput cols)

# Loop through the iterations
for ((i=1; i<=$iterations; i++)); do
  # Calculate the progress percentage
  percentage=$((100 * i / iterations))
  # Calculate the width of the progress bar
  barwidth=$((termwidth - 8))
  # Calculate the number of characters to print for the progress bar
  numchars=$((percentage * barwidth / 100))
  # Print the progress bar
  printf "["
  for ((j=0; j<$numchars; j++)); do
    printf "="
  done
  if [[ $percentage -eq 100 ]]; then
    printf "=%*s] %d%%\r" $((barwidth - numchars)) "" $percentage
  else
    printf ">%*s] %d%%\r" $((barwidth - numchars)) "" $percentage
  fi
  # Do some work here
  sleep 0.1
done
echo ""
