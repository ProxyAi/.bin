#!/bin/bash

# Author: admin@xoren.io
# Script: update_grub_background.sh
# Link https://github.com/xorenio
# Description: Script change out the grub background and logo images .

THEME_DIRECTORY="/usr/share/grub/themes"
GRUB_CONFIG_FILE="/etc/default/grub"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STARTING_LOCATION="$(pwd)"

THEME_NAME="$(grep -oE 'GRUB_THEME="[^"]+"' "${GRUB_CONFIG_FILE}" | sed -E 's/GRUB_THEME="([^"]+)".*/\1/' | sed -E "s#${THEME_DIRECTORY}/##g"  | awk -F '/' '{print $1}')"

cd "${SCRIPT_DIR}"

if [[ -f "${SCRIPT_DIR}/logo.png" ]];
then
    if ! cmp -s "logo.png" "${THEME_DIRECTORY}/${THEME_NAME}/logo.png";
    then
        ## DELETE LOGO
        [[ -f "${THEME_DIRECTORY}/${THEME_NAME}/logo.png" ]] && rm "${THEME_DIRECTORY}/${THEME_NAME}/logo.png"

        ## COPY OVER NEW LOGO
        cp "logo.png" "${THEME_DIRECTORY}/${THEME_NAME}/"

        ## ALL ACCESS
        chmod 777 "${THEME_DIRECTORY}/${THEME_NAME}/logo.png"
    fi
fi

if [[ -f "${SCRIPT_DIR}/background.png" ]];
then
    if ! cmp -s "background.png" "${THEME_DIRECTORY}/${THEME_NAME}/background.png"; then
        ## DELETE BACKGROUND
        [[ -f "${THEME_DIRECTORY}/${THEME_NAME}/background.png" ]] && rm "${THEME_DIRECTORY}/${THEME_NAME}/background.png"
        [[ -f "${THEME_DIRECTORY}/background.png" ]] && rm "${THEME_DIRECTORY}/background.png"

        ## COPY OVER NEW BACKGROUND
        cp "background.png" "${THEME_DIRECTORY}/${THEME_NAME}/"
        cp "background.png" "${THEME_DIRECTORY}/"

        ## ALL ACCESS
        chmod 777 "${THEME_DIRECTORY}/${THEME_NAME}/background.png"
    fi
fi

cd "${STARTING_LOCATION}"