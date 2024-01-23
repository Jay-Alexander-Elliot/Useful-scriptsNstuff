#!/bin/bash

# Define constants for colors, reset
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print error messages
print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Check if AWS CLI is installed
check_aws_cli() {
    if ! [ -x "$(command -v aws)" ]; then
        print_error "Error: AWS CLI is not installed.\nTo install AWS CLI do the following:\n"
        echo """
            curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip
            sudo ./aws/install && rm -rf aws awscliv2.zip
        """
        exit 1
    fi
}

# Main function to handle AWS operations
aws_operations() {
    # Your existing logic for AWS operations
    # ...
}

# Check for AWS CLI early
check_aws_cli

# Process command-line arguments
while getopts "a:b:c:" opt; do
    case $opt in
        a) # Handle argument a
            ;;
        b) # Handle argument b
            ;;
        c) # Handle argument c
            ;;
        \?) # Handle invalid options
            print_error "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

# Call main function
aws_operations "$@"

# Add any additional logic or function calls
# ...
