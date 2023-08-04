#!/bin/bash

# Author: admin@xoren.io
# Script: github_repo_update.sh
# Link https://github.com/xorenio
# Description: Basic script to update the local repo copy to the remote version.

SCRIPT="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"


cd $SCRIPT_DIR
GITHUB_REPO_OWNER="xorenio"
GITHUB_REPO_NAME="twisted-project-zomboid"

NOWDATESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
GITHUB_REPO_URL="https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/commits"
#GITHUB_REPO_URL="https://api.github.com/repo/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}"

#cd ~/$GITHUB_REPO_NAME/

if [[ ! -f "$HOME/.github_token" ]]; then

     echo "Failed deployment" ${NOWDATESTAMP}
     echo ""
     echo "Missing github token file .github_token"
     echo "GIHHUB_TOKEN=ghp_####################################"
     echo "public_repo, read:packages, repo:status, repo_deployment"
     exit 1;
fi

if [[ -f "$HOME/.${SCRIPT}_running" ]]; then
 exit
fi

echo ${NOWDATESTAMP} > "$HOME/.${SCRIPT}_running"
echo "Starting deployment check" ${NOWDATESTAMP}

#if [[ ! -f ~/$GITHUB_REPO_NAME/.env ]]; then
#
#     cp ~/$GITHUB_REPO_NAME/.env.prod ~/$GITHUB_REPO_NAME/.env
#fi

source $SCRIPT_DIR/.env
source "$HOME/.github_token"


DATA=$( curl -s -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GIHHUB_TOKEN" \
  $GITHUB_REPO_URL)
#https://api.github.com/orgs/$GITHUB_REPO_OWNER/packages/container/$GITHUB_PACKAGE_NAME)

#NEW_VERSION=$(echo $DATA | jq -r .version_count)

#echo "Current file version $APP_VERSION"
#echo "Github file version $NEW_VERSION"

echo $DATA | jq .[0].commit.tree.sha

#curl --user "caspyin:PASSWD" https://api.github.com/users/caspyin


rm "$HOME/.${SCRIPT}_running"

exit;
