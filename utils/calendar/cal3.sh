#!/bin/bash

# Get current year and month
year=$(date +%Y)
month=$(date +%m)

# Print month and year
echo "$(date +%B\ %Y)"

# Print the days of the week
echo "Su Mo Tu We Th Fr Sa"

# Get the first day of the month
first_day=$(date -d "$year-$month-01" +%w)

# Fetch bank holidays and store them in an array
holidays=$(curl -s https://www.gov.uk/bank-holidays.json | jq -r '.["england-and-wales"].events[] | select(.date | startswith($month)) | .date[8:10]')
#holidays=$(curl -s https://www.gov.uk/bank-holidays.json | jq --arg month "$year-$month" '.england-and-wales.events[] | select(.date | startswith($month)) | .date[8:10]')
#bank_holidays=($(curl -s https://www.gov.uk/bank-holidays.json | jq -r ".england-and-wales.events[] | select(.date | startswith(\"$year-$month\")) | .date[8:10]"))

# Create the calendar
for ((i=0; i<$first_day; i++)); do
    printf "   "
done
for ((day=1; day<=31; day++)); do
    if (( day < 10 )); then
        printf " "
    fi
    if (( day == $(date +%e) && month == $(date +%m) )); then
        printf "\e[7m%s\e[0m " $day
    elif [[ $holidays =~ $'\b'$day$'\b' ]]; then
        printf "\e[32m%s\e[0m " $day
    else
        printf "%s " $day
    fi
    if (( $(($day+$first_day)) % 7 == 0 )); then
        printf "\n"
    fi
done
printf "\n"
