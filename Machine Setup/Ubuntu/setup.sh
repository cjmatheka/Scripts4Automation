#!/bin/env bash

# List of scripts to be executed in order
script_list=(
    "setup.sh"
)

# Function to execute a script
execute_script() {
    local script="$1"

    # Check if the script exists and is executable
    if [ -x "$script" ]; then
        echo "Running $script..."
        ./$script

        # Check if the script executed successfully
        if [ $? -eq 0 ]; then
            echo "$script completed successfully."
        else
            echo "Error: $script failed with error code $?."
            exit 1
        fi
    else
        echo "Error: $script not found or is not executable."
        exit 1
    fi
}

# Loop through each script in the list and execute it
for script in "${script_list[@]}"; do
    execute_script $script
done

echo "All scripts executed successfully."
