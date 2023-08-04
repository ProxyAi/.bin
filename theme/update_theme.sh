#!/bin/bash

# Author: admin@xoren.io
# Script: update_theme.sh
# Link https://github.com/xorenio
# Description: Script change out the grub background and logo images .

## START - CONFIGS

DESTINATION_DIRECTORY="$HOME/.themes"
GITHUB_REPO_OWNER="Fausto-Korpsvart"
GITHUB_REPO_NAME="Tokyo-Night-GTK-Theme"
GITHUB_REPO_URL="https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/commits"

THEME_FOLDER="Tokyonight-Dark-BL"

TIMESTAMP="$(date "+%Y-%m-%d_%H-%M-%S")"
STARTING_LOCATION="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_VERSION_FILE="${DESTINATION_DIRECTORY}/${THEME_FOLDER}/.version"

## END - CONFIGS


## START - FUNCTIONS

# START - SPINNER

# Function: _spinner
# Description: Display a spinner animation.
# Parameters: None
# - $1 process id
# Returns: None

_spinner() {
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

# END - SPINNER


# START - RUNNING FILE

SCRIPT_RUNNING_FILE=${SCRIPT_RUNNING_FILE:-"${HOME}/${GITHUB_REPO_NAME}_running.txt"}

# Function: _create_running_file
# Description: Creates a running file with the current date and time.
# Parameters: None
# Returns: None

_create_running_file() {
    echo "${TIMESTAMP}" > "${SCRIPT_RUNNING_FILE}"
}

# Function: _check_running_file
# Description: Checks if the running file exists and exits the script if it does.
# Parameters: None
# Returns: None

_check_running_file() {
    if [[ -f "${SCRIPT_RUNNING_FILE}" ]]; then
        echo "Script already running."
        exit
    fi
}

# Function: _delete_running_file
# Description: Deletes the running file.
# Parameters: None
# Returns: None

_delete_running_file() {
    if [[ -f "${SCRIPT_RUNNING_FILE}" ]]; then
        rm "${SCRIPT_RUNNING_FILE}"
    fi

    cd "${STARTING_LOCATION}" || cd "$HOME" || return
}

# END - RUNNING FILE


# START - EXIT SCRIPT

# Function: _exit_script
# Description: Graceful exiting of script.
# Parameters: None
# Returns: None

_exit_script() {
    _delete_running_file
    cd "${STARTING_LOCATION}" || exit
    exit;
}

# END - EXIT SCRIPT


# START - GITHUB API

# Function: _get_project_github_latest_sha
# Description: Curls the github api for commit latest sha.
# Parameters: None
# Returns: None

_get_project_github_latest_sha() {

    local curl_data gh_sha;
    curl_data=$( curl -s -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version:2022-11-28" \
        "$GITHUB_REPO_URL")

    if [[ $(echo "$curl_data" | jq -r .message 2> /dev/null && echo 1) ]]; then
        # echo "$curl_data" | jq .message
        echo 0;
        return;
    fi

    if [[ $(echo "$curl_data" | jq -r .[0].commit.tree.sha 2> /dev/null && echo 1) ]]; then
        gh_sha="$(echo "$curl_data" | jq .[0].commit.tree.sha)"
        echo "${gh_sha//\"}"
        return;
    fi
}
# END - GITHUB API

# START - UPDATE

# Function: _get_project_github_latest_sha
# Description: Curls the github api for commit latest sha.
# Parameters: None
# Returns: None

_update() {

    cd "$SCRIPT_DIR"

    git clone -q https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git &

    _spinner $! "Downloading New Copy of Theme" "Downloaded New Copy of Theme"


    cp -R --update "${GITHUB_REPO}/${THEME_FOLDER}" "$DESTINATION_DIRECTORY/"

    _spinner $! "Updating Theme Directory" "Updated Theme Directory"

    echo "$remote_version" > "$LOCAL_VERSION_FILE"
}
# END - UPDATE


## END - FUNCTIONS


## START - MAIN RUNTIME

_check_running_file

_create_running_file


if [[ -d "${DESTINATION_DIRECTORY}/${THEME_FOLDER}" ]]; then
  if [[ -f "${DESTINATION_DIRECTORY}/${THEME_FOLDER}/.version" ]]; then
    version=$(cat "$LOCAL_VERSION_FILE")
    remote_version=$(_get_project_github_latest_sha);
    if [[ "$remote_version" = "0" ]]; then
      echo "Error: github api failure."
    fi
    if [[ "$remote_version" -ne "$version" ]]; then
      _update
    fi
    _exit_script
  else
    _update
    _exit_script
  fi

  rm -R ${GITHUB_REPO}/ & 
  _spinner $! "Deleting Old Theme Directory" "Deleted Old Theme Directory"
fi

_exit_script
exit

## END - MAIN RUNTIME
