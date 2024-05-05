#!/usr/bin/env bash

# Function to remove a Git repository
removeRepoDir() {
  # Get the repository name from the user (or passed as argument)
  if [ $# -eq 0 ]; then
    read -r -p "Enter the name of the Git repository to delete: " repo_to_delete
  else
    repo_to_delete="$1"
  fi

  # Check if the directory exists and is a Git repository
  if [ ! -d "$repo_to_delete/.git" ]; then
    echo "No Git repository found named '$repo_to_delete'."
    return 1
  fi

  # Confirmation for removing Git tracking (local files will remain)
  read -r -p "Type 'y' or 'n' to confirm removal of Git tracking (local files will remain): " GitDelete
  if [ "$GitDelete" = "y" ]; then
    echo "Removing Git tracking..."
    rm -rf "$repo_to_delete/.git"
  elif [ "$GitDelete" = "n" ]; then
    echo "Git tracking not removed."
    echo "Deletion cancelled by user."
    return 0
  else
    echo "Option not recognized. Please type 'y' or 'n'."
  fi

  # Confirmation for deleting the local directory
  read -r -p "Type 'y' or 'n' to delete the directory '$repo_to_delete' and its files?: " DirDelete
  if [ "$DirDelete" = "y" ]; then
    # Get the full path of the directory (optional for clarity)
    full_path=$(realpath "$repo_to_delete")
    echo "Deleting repository directory..."

    # Check if directory is empty before deleting (optional)
    if [ "$(ls -A $full_path)" ]; then
      echo "Warning: Directory is not empty. This will delete all contents!"
      read -r -p "Are you sure you want to continue (y/n)? " confirm_delete
      if [[ $confirm_delete =~ ^[y]$ ]]; then
        rm -rf "$full_path"
      else
        echo "Deletion cancelled."
      fi
    else
      rm -rf "$full_path"
    fi
  elif [ "$DirDelete" = "n" ]; then
    echo "Directory not deleted."
    echo "Deletion cancelled by user."
  else
    echo "Option not recognized. Please type 'y' or 'n'."
  fi

  # Confirmation for deleting the remote repository
  read -r -p "Type 'y' or 'y' to delete the remote repository '$repo_to_delete' on GitHub: " RemoteDelete
  if [ "$RemoteDelete" = "y" ]; then
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
