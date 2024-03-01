#!/bin/bash

# Define the root directory to start searching from
# Adjust this path as needed. Use "." to represent the current directory
root_directory="."

# Function to delete directories with a specific name
delete_directories () {
    local dir_name=$1 # Name of the directory to delete
    echo "Searching for and deleting directories named '$dir_name'"

    # Find and delete directories recursively
    find "$root_directory" -type d -name "$dir_name" -exec rm -rf {} +
}

# Delete "meta" directories
delete_directories "meta"

# Delete "test" directories
delete_directories "test"

echo "Deletion process complete."

