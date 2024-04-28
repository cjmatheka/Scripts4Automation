#!/usr/bin/env bash

removeRepoDir() {
  # Get the current directory name as the repository to delete
  repo_to_delete=$(basename "$(pwd)")

  # Check if the directory exists
  if [ ! -d ".git" ];
  then
    echo "No Git repository found in the current directory."
    return 1
  fi

  # Confirmation for removing Git tracking
  read -r -p "Type 'Yes' or 'No' to confirm removal of Git tracking (local files will remain): " GitDelete
  if [ "$GitDelete" = "Yes" ]; then
    echo "Removing Git tracking..."
    rm -rf .git
  elif [ "$GitDelete" = "No" ]; then
    echo "Git tracking not removed."
    echo "Deletion cancelled by user."
    return 0
  else
    echo "Option not recognized. Please type 'Yes' or 'No'."
  fi

  # Confirmation for deleting the local directory
  read -r -p "Type 'Yes' or 'No' to delete the directory '$repo_to_delete' and its files?: " DirDelete
  if [ "$DirDelete" = "Yes" ]; then
    # Get the full path of the directory
    full_path=$(realpath "$repo_to_delete")
    echo "Deleting repository directory..."

    # Check if directory is empty before deleting (optional)
    if [ "$(ls -A $full_path)" ]; then
      echo "Warning: Directory is not empty. This will delete all contents!"
      read -r -p "Are you sure you want to continue (y/N)? " confirm_delete
      if [[ $confirm_delete =~ ^[Yy]$ ]]; then
        rm -rf "$full_path"
      else
        echo "Deletion cancelled."
      fi
    else
      rm -rf "$full_path"
    fi
  elif [ "$DirDelete" = "No" ]; then
    echo "Directory not deleted."
    echo "Deletion cancelled by user."
  else
    echo "Option not recognized. Please type 'Yes' or 'No'."
  fi

  # Confirmation for deleting the remote repository
  read -r -p "Type 'Yes' or 'No' to delete the remote repository '$repo_to_delete' on GitHub: " RemoteDelete
  if [ "$RemoteDelete" = "Yes" ]; then
    # Check for remote repository existence
    response=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$USERNAME/$repo_to_delete)
    if [ "$response" = "200" ]; then
      echo "Removing remote repository..."
      curl -X DELETE -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$USERNAME/$repo_to_delete
      echo "Remote repository '$repo_to_delete' deleted successfully."
    else
      echo "Remote repository does not exist or not found."
    fi
  elif [ "$RemoteDelete" = "No" ]; then
    echo "Remote repository not removed."
    echo "Deletion cancelled by user."
  else
    echo "Option not recognized. Please type 'Yes' or 'No'."
  fi
}
