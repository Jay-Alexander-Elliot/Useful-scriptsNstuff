#!/bin/bash

# Enhanced script to create a directory and file structure for cloud infrastructure projects.
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
    echo "Placeholder for $file" > "$dir/$file"
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
for module in lambda-functions api-gateway dynamodb sns; do
    for file in main.tf variables.tf outputs.tf versions.tf; do
        create_structure "$BASE_DIR/modules/$module" "$file"
    done
done

# Create src directory for Lambda functions
SRC_DIR="$BASE_DIR/src/lambda-functions"
mkdir -p "$SRC_DIR"
echo "Placeholder for handler.ts" > "$SRC_DIR/handler.ts"
echo "Placeholder for tsconfig.json" > "$SRC_DIR/tsconfig.json"

# Create Bamboo CI config
CI_DIR="$BASE_DIR/.bambooci"
mkdir -p "$CI_DIR"
echo "Placeholder for config.yml" > "$CI_DIR/config.yml"

# Create .gitignore and README.md in the root
echo "Placeholder for .gitignore" > "$BASE_DIR/.gitignore"
echo "Placeholder for README.md" > "$BASE_DIR/README.md"

echo "Directory structure and files created successfully."

