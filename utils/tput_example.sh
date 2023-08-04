# Move cursor to row 5, column 10
tput cup 5 10
echo "Hello, world!"

# Save cursor position
tput sc

# Move cursor to row 10, column 10
tput cup 10 10
echo "Saved position."

# Restore cursor position
tput rc
