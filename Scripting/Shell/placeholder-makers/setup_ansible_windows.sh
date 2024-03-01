#!/bin/bash

# Script to create a directory and file structure for Ansible Windows configuration projects.
# Now checks for existing files and directories before creating them.
# Usage:
#   ./setup_ansible_windows.sh [--clean]

# Exit on error
set -e

# Base directory (absolute path)
BASE_DIR="$(dirname "$(realpath "$0")")/Windows-configuration"

# Function to create directory and file structure
create_structure() {
    local dir="$1"
    local file="$2"
    mkdir -p "$dir"
    if [ ! -f "$dir/$file" ]; then
        echo "Creating $dir/$file"
        echo "# Placeholder for $file" > "$dir/$file"
    else
        echo "$dir/$file already exists, skipping creation."
    fi
}

# Function to clean up directories
cleanup() {
    echo "Cleaning up existing directories..."
    rm -rf "$BASE_DIR"
}

# Check for cleanup flag
if [ "$1" == "--clean" ]; then
    cleanup
    exit 0
fi

# Directories and files to create
declare -A structure=(
    ["$BASE_DIR/inventory/"]="inventory.ini"
    ["$BASE_DIR/playbooks/"]="main.yml windows_playbook.yml windows_packages.yml windows_privacy.yml"
    ["$BASE_DIR/roles/common/tasks/"]="main.yml"
    ["$BASE_DIR/roles/windows10-packages/tasks/"]="main.yml"
    ["$BASE_DIR/roles/windows10-privacy/tasks/"]="main.yml disable_advertising_id.yml disable_cortana_features.yml disable_feedback.yml disable_tailored_experiences.yml disable_web_search.yml uninstall_internet_explorer.yml uninstall_telnet_client.yml"
    ["$BASE_DIR/files/"]="autounattend.xml"
    ["$BASE_DIR/group_vars/"]="windows.yml all.yml"
)

# Create structure
for dir in "${!structure[@]}"; do
    files=${structure[$dir]}
    for file in $files; do
        create_structure "$dir" "$file"
    done
done

# Create .gitignore and README.md in the root
if [ ! -f "$BASE_DIR/.gitignore" ]; then
    echo "Creating $BASE_DIR/.gitignore"
    echo "Placeholder for .gitignore" > "$BASE_DIR/.gitignore"
else
    echo "$BASE_DIR/.gitignore already exists, skipping creation."
fi

if [ ! -f "$BASE_DIR/README.md" ]; then
    echo "Creating $BASE_DIR/README.md"
    echo "# Placeholder for README.md" > "$BASE_DIR/README.md"
else
    echo "$BASE_DIR/README.md already exists, skipping creation."
fi

echo "Ansible Windows configuration directory structure and files creation/update completed successfully."
