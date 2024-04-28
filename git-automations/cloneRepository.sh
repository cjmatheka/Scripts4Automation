#!/bin/bash

# Function to handle errors and exit with a message
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Function to clone a Git repository
clone_repository() {
  # Get the repository name as an argument
  local REPO_NAME="$1"

  # Check if the repository name is empty
  if [ -z "$REPO_NAME" ];
  then
    error_exit "Please provide a repository name."
  fi

  # Construct the repository URL (assuming a standard GitHub format)
  REPO_URL="https://github.com/$GIT_USERNAME/$REPO_NAME.git"

  # Check if the directory already exists
  if [ -d "$REPO_NAME" ];
  then
    echo "Directory '$REPO_NAME' already exists."
    read -r -p "Do you want to clone into a subdirectory (y/N)? " CREATE_SUBDIR

    if [[ $CREATE_SUBDIR =~ ^[Yy]$ ]];
    then
      read -r -p "Enter subdirectory name: " SUBDIR_NAME
      REPO_NAME="$SUBDIR_NAME"
    fi
  fi

  # Clone the repository using Git
  git clone "$REPO_URL" "$REPO_NAME" || error_exit "Failed to clone repository."

  echo "Successfully cloned repository to '$REPO_NAME'."
}