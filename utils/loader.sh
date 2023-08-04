#!/bin/bash

# Author: admin@xoren.io
# Script: loader.sh
# Link https://github.com/xorenio
# Description: More complicated spinner.

# Check if the terminal supports certain capabilities
has_ascii_support() {
  local support=1

  # Check if the terminal supports cursor movement
  if ! tput cr && ! tput cub1 && ! tput cuf1; then
    support=0
  fi

  # Check if the terminal supports clearing the line
  if ! tput el; then
    support=0
  fi

  # Check if the terminal supports printing ASCII characters
  if ! printf 'a'; then
    support=0
  fi

  return "$support"
}

# Display a spinner animation
spinner() {
  saved_position=$(tput sc)

  # Hide the cursor
  tput civis
  echo -n -e '\e[?25l'


  # Get the size of the terminal window
  rows=$(tput lines)
  columns=$(tput cols)
  # Define the ANSI escape code to reset text color
  local RESET='\033[0m'
  # Define the ANSI escape code for green color
  local GREEN='\033[0;32m'

  local pid=$1
  local STARTING_TITLE=$2
  local FINISHING_TITLE=$3
  local delay=0.2

  # Determine the spinner characters based on ASCII support
  if has_ascii_support; then
    local spinstr='⣾⣽⣻⢿⡿⣟⣯⣷'
  else
    local spinstr='|\-/'
  fi

  local i=0

  # Move the cursor to the beginning of the line
  tput cr

  # Print the starting title
  echo -e "[ ] ${STARTING_TITLE}"

  # Put the cursor at the beginning of the line
  tput cuf1

  # Move the cursor to the appropriate position
  for ((i=0; i<${#STARTING_TITLE} + 3; i++))
  do
    tput cuf1
  done

  tput cuu1

  # Fill remaining space with spaces
  for ((i=1; i<columns - ${#STARTING_TITLE} - 3; i++))
  do
    printf " "
  done

  tput cr
  echo -e "${saved_position}"

  while kill -0 "$pid" 2>/dev/null
  do
    # Move the cursor to the beginning of the line
    tput cr

    # Print the spinner character
    printf "[%c]" "${spinstr:$i:1}"
    tput cr
    sleep $delay
    printf "\b"
    ((i = (i + 1) % 4))
  done

  # Calculate the length of the finishing title
  local string_length=$((${#FINISHING_TITLE} + 7))

  # Calculate the remaining space
  local remaining_columns=$((columns - string_length + 1))

  # Move the cursor to the beginning of the line
  tput cr

  # Print the finishing title with green color
  echo -e "[${GREEN}✓${RESET}] ${FINISHING_TITLE}"

  # Move the cursor to the appropriate position
  for ((i=0; i<string_length; i++))
  do
    tput cuf1
  done

  # Fill remaining space with spaces
  for ((i=1; i<remaining_columns; i++))
  do
    echo -n " "
  done

  # Restore cursor to the saved position
  tput rc

  # Show the cursor again
  tput cnorm
  echo -n -e '\e[?25h'
}

# Simulate some work
sleep 5 &

# Start the spinner in the background
spinner $! "Building docker image" "Building"

# Simulate some work
sleep 5 &
spinner $! "Building KVM" "Building KVM - Finished!"

# Simulate some work
sleep 5 &
spinner $! "Hacking " "Hacking your moms basement !"


echo "Process completed!"
