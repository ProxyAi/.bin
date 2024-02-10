#!/bin/bash

# Author: admin@xoren.io
# Script: github_repo_update.sh
# Link https://github.com/xorenio
# Description: Basic script to update the local repo copy to the remote version.

SCRIPT="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd $SCRIPT_DIR

NOWDATESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
CF_TOKEN=""
CF_ACCOUNT_ID=""
CF_PROJECT_ID=${1:-"stocktaking"}
CF_API_URL="https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/pages/projects/${CF_PROJECT_ID}/domains"

DATA=$(curl -s -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $CF_TOKEN" \
  $CF_API_URL)

echo $DATA | jq .

exit
