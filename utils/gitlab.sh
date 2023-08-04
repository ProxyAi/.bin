#!/bin/bash

# Author: admin@xoren.io
# Script: gitlab_repo_update.sh
# Link https://github.com/xorenio
# Description: Basic script to update the local repo copy to the remote version.

# Set your personal access token here
GITLAB_ACCESS_TOKEN="your_personal_access_token_here"

# Set the target GitLab project
PROJECT="veloren/veloren"

# Set the target container registry repository and tag
REPOSITORY="server-cli"
TAG="weekly"

# Fetch the Container Registry details using GitLab API
CONTAINER_REGISTRY_ID=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT" | jq '.container_registry_id')

# Get the list of tags for the given repository
TAGS_LIST=$(curl "https://gitlab.com/api/v4/container_registries/$CONTAINER_REGISTRY_ID/repositories/$REPOSITORY/tags")

# Extract the timestamp of the last uploaded image with the specified tag
LAST_UPLOAD_TIMESTAMP=$(echo "$TAGS_LIST" | jq -r --arg TAG "$TAG" '.[] | select(.name == $TAG) | .created_at')

# Print the timestamp of the last uploaded image
echo "Last uploaded image (tag: $TAG) in the repository \"$REPOSITORY\" was on:"
echo "$LAST_UPLOAD_TIMESTAMP"













# Set your variables
#GITLAB_TOKEN="your-personal-access-token"
#PROJECT_ID="your-gitlab-project-id"
#REPOSITORY_NAME="veloren/server-cli"
#TAG_NAME="weekly"

# Get last upload timestamp for the image
#last_upload_timestamp=$(curl --silent "https://gitlab.com/api/v4/projects/${PROJECT_ID}/registry/repositories/${REPOSITORY_NAME}/tags/${TAG_NAME}" | jq '.created_at')

# Check if the timestamp is retrieved successfully
#if [ "$last_upload_timestamp" != "null" ]; then
#  echo "Last upload timestamp for registry.gitlab.com/veloren/veloren/server-cli:weekly is: ${last_upload_timestamp}"
#else
#  echo "Error: Could not retrieve the last upload timestamp for registry.gitlab.com/veloren/veloren/server-cli:weekly"
#fi
