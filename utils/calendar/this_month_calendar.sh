#!/bin/bash

# Author: admin@xoren.io
# Script: this_month_calendar.sh
# Link https://github.com/xorenio
# Description: Script to display this month in a calendar format in the terminal .

# Get the current year and month
year=$(date +%Y)
month=$(date +%m)

# Get the number of days in the current month
days=$(date -d "$year-$month-01 +1 month -1 day" +%d)

# Get the day of the week for the first day of the month
first_day=$(date -d "$year-$month-01" +%u)

# Print the month and year
echo "$(date +%B) $year"

# Print the days of the week
echo "Su Mo Tu We Th Fr Sa"

# Print the calendar
for ((i=1; i<$first_day; i++)); do
  printf "   "
done

for ((i=1; i<=$days; i++)); do
  printf "%2d " $i

  if (( ($i + $first_day - 1) % 7 == 0 )); then
    echo ""
  fi
done

echo ""
