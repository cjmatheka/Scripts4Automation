#!/usr/bin/env bash

# Assign environmental variables to local variables
GITHUB_TOKEN="$GITHUB_TOKEN"
GIT_USERNAME="$GIT_USERNAME"
GIT_EMAIL="$GIT_EMAIL"

# Source the files containing functions
source handleGitConfigs.sh
source createGitRepo.sh
source handleGitOperations.sh
source gitRepoDelete.sh
source createRemoteRepo.sh
source pushingToRemote.sh
source checkGitRepo.sh
source cloneRepository.sh

# Main function to execute the script
main() {
  local ACTION=$1

  # Check if the .git directory exists
  if [ "$ACTION" = "create" ];
  then
    echo "Creating a new repository..."
    check_and_configure_git
    create_github_repo

  elif [ "$ACTION" = "clone" ];
  then
    echo "Cloning repository..."
    clone_repository

  elif [ "$ACTION" = "update" ];
  then
    echo "Checking if its a repository..."
    echo "Adding, commiting, and pushing changes"
    checkGitRepo
    perform_git_operations

  elif [ "$ACTION" = "delete" ];
  then
    echo "This action is irreversible. You will be asked to confirm."
    echo "Deleting the repository...."
    removeRepoDir

  else
    echo "Invalid command argument provided..."
    echo "Specify either 'create' to create a new repo or 'update' to update your changes"
  fi
}
# Call the main function
main "$1"
