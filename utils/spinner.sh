#!/bin/bash

# Author: admin@xoren.io
# Script: progress.sh
# Link https://github.com/xorenio
# Description: A script to display a spinner for processes.

# Check if the terminal supports certain capabilities
# has_ascii_support() {
#   local support=1
#   # Check if the terminal supports cursor movement
#   # ! tput cr && ! tput cub1 && ! tput cuf1 && support=0

#   # Check if the terminal supports clearing the line
#   # ! tput el && support=0

#   # Check if the terminal supports printing ASCII characters
#   ! printf 'a' && support=0

#   return "$support"
# }

# Display a spinner animation
spinner() {
  # Move the cursor to the beginning of the current line
  tput cr
  # Save current cursor position
  tput sc
  # Hide the cursor
  tput civis
  echo -n -e '\e[?25l'
  # Determine the spinner characters based on ASCII support
  if ! printf 'a'; then
    local spinstr='⣾⣽⣻⢿⡿⣟⣯⣷'
  else
    local spinstr='|\-/'
  fi
  # Move the cursor to the beginning of the current line
  tput cr
  # Print the starting title
  echo -e "[ ] $2"
  # Load saved cursor position
  tput rc
  # tput cuu 1
  # Move the cursor to the beginning of the current line
  tput cr
  while kill -0 "$1" 2>/dev/null
  do
    # Print the spinner character
    printf "[%c]" "${spinstr:$i:1}"
    tput cr
    sleep 0.1
    printf "\b"
    ((i = (i + 1) % 4))
  done
  # Move the cursor to the beginning of the current line
  tput cr
  # Clear current terminal line
  tput el
  # Print the finishing title with green color
  echo -e "[\033[0;32m✓\033[0m] $3"
  # Move the cursor to the beginning of the current line
  tput cr
  # Show the cursor again
  tput cnorm
  echo -n -e '\e[?25h'
}

# Simulate some work
sleep 3 &

# Start the spinner in the background
spinner $! "age - Building docker image -  image - Building docker image" "Building"

# Simulate some work
sleep 3 &
spinner $! "Building KVM" "Building KVM - Finished!"

# Simulate some work
sleep 3 &
spinner $! "Hacking " "Hacking your moms basement !"


echo "Process completed!"
