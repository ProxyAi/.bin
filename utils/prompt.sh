#!/bin/bash

# Author: admin@xoren.io
# Script: prompt.sh
# Link https://github.com/xorenio
# Description: Displays user prompt.

# Function for terminal prompt
terminal_prompt() {
    read -p "Do you want to proceed? [Y/n] " ans
    case $ans in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

# Check if zenity is installed
if command -v zenity >/dev/null 2>&1 ; then
    if zenity --question --text="Do you want to proceed?"; then
        echo "User selected Yes"
    else
        echo "User selected No"
    fi
# Check if yad is installed
elif command -v yad >/dev/null 2>&1 ; then
    if yad --question --text="Do you want to proceed?"; then
        echo "User selected Yes"
    else
        echo "User selected No"
    fi
# Fallback to terminal
else
    if terminal_prompt; then
        echo "User selected Yes"
    else
        echo "User selected No"
    fi
fi
