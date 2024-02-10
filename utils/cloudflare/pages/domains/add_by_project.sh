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

DATA=$(curl -s --request POST \
  --url "$CF_API_URL" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $CF_TOKEN" \
  --data '{"name": "cftest.pcwcloud.co.uk"}')

echo $DATA | jq .

exit
# with domain in account
# {
#   "result": {
#     "id": "37d0c182-884f-4e28-9043-d4638b04dbf5",
#     "domain_id": "37d0c182-884f-4e28-9043-d4638b04dbf5",
#     "name": "cftest.stocktaking.app",
#     "status": "initializing",
#     "verification_data": {
#       "status": "pending"
#     },
#     "validation_data": {
#       "status": "initializing",
#       "method": "http"
#     },
#     "certificate_authority": "lets_encrypt",
#     "zone_tag": "10c6f3cf0bb6de0b5060404e66ce2dab",
#     "created_on": "2024-01-02T18:20:35.591773Z"
#   },
#   "success": true,
#   "errors": [],
#   "messages": []
# }

# external domain

# {
#   "result": {
#     "id": "a794eed8-cdee-4756-b8a2-64e5ee6213d9",
#     "domain_id": "a794eed8-cdee-4756-b8a2-64e5ee6213d9",
#     "name": "cftest.pcwcloud.co.uk",
#     "status": "initializing",
#     "verification_data": {
#       "status": "pending"
#     },
#     "validation_data": {
#       "status": "initializing",
#       "method": "http"
#     },
#     "certificate_authority": "lets_encrypt",
#     "created_on": "2024-01-02T18:40:05.678675Z"
#   },
#   "success": true,
#   "errors": [],
#   "messages": []
# }
