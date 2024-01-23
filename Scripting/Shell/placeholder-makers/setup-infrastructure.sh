#!/bin/bash

# Enhanced script to create a directory and file structure for cloud infrastructure projects.
# Now checks for existing files and directories before creating them.
# Usage:
#   ./setup_project.sh [--clean]

# Exit on error
set -e

# Base directory (absolute path)
BASE_DIR="$(dirname "$(realpath "$0")")"

# Function to create directory and file structure
create_structure() {
    local dir="$1"
    local file="$2"
    mkdir -p "$dir"
    if [ ! -f "$dir/$file" ]; then
        echo "Creating $dir/$file"
        echo "Placeholder for $file" > "$dir/$file"
    else
        echo "$dir/$file already exists, skipping creation."
    fi
}

# Function to clean up directories
cleanup() {
    echo "Cleaning up existing directories..."
    rm -rf "$BASE_DIR/environments" "$BASE_DIR/modules" "$BASE_DIR/../src" "$BASE_DIR/../.bambooci" "$BASE_DIR/../.gitignore" "$BASE_DIR/../README.md"
}

# Check for cleanup flag
if [ "$1" == "--clean" ]; then
    cleanup
    exit 0
fi

# Create environments
for env in sandbox dev prod; do
    for file in main.tf variables.tf outputs.tf versions.tf; do
        create_structure "$BASE_DIR/environments/$env" "$file"
    done
done

# Create modules with submodules
for module in lambda-functions api-gateway dynamodb sns eventbridge; do
    for file in main.tf variables.tf outputs.tf versions.tf; do
        create_structure "$BASE_DIR/modules/$module" "$file"
    done
done

# Create src directory for Lambda functions
SRC_DIR="$BASE_DIR/src/lambda-functions"
mkdir -p "$SRC_DIR"
if [ ! -f "$SRC_DIR/handler.ts" ]; then
    echo "Creating $SRC_DIR/handler.ts"
    echo "Placeholder for handler.ts" > "$SRC_DIR/handler.ts"
else
    echo "$SRC_DIR/handler.ts already exists, skipping creation."
fi

if [ ! -f "$SRC_DIR/tsconfig.json" ]; then
    echo "Creating $SRC_DIR/tsconfig.json"
    echo "Placeholder for tsconfig.json" > "$SRC_DIR/tsconfig.json"
else
    echo "$SRC_DIR/tsconfig.json already exists, skipping creation."
fi

# Create Bamboo CI config
CI_DIR="$BASE_DIR/.bambooci"
mkdir -p "$CI_DIR"
if [ ! -f "$CI_DIR/config.yml" ]; then
    echo "Creating $CI_DIR/config.yml"
    echo "Placeholder for config.yml" > "$CI_DIR/config.yml"
else
    echo "$CI_DIR/config.yml already exists, skipping creation."
fi

# Create .gitignore and README.md in the root
if [ ! -f "$BASE_DIR/.gitignore" ]; then
    echo "Creating $BASE_DIR/.gitignore"
    echo "Placeholder for .gitignore" > "$BASE_DIR/.gitignore"
else
    echo "$BASE_DIR/.gitignore already exists, skipping creation."
fi

if [ ! -f "$BASE_DIR/README.md" ]; then
    echo "Creating $BASE_DIR/README.md"
    echo "Placeholder for README.md" > "$BASE_DIR/README.md"
else
    echo "$BASE_DIR/README.md already exists, skipping creation."
fi

echo "Directory structure and files creation/update completed successfully."

