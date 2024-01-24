#!/usr/bin/env bash
# Title: AWS Console Login Helper
# Description: This script facilitates logging into an AWS account by creating a URL using the .aws/credentials file. It ensures the aws-console tool is installed and the AWS credentials are properly set. It also allows specifying which browser to use for opening the AWS console.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: ./aws_console_login_helper.sh [browser] [aws-profile]
# Example: ./aws_console_login_helper.sh firefox development

# Function to install aws-console
install_aws_console() {
    echo "Installing aws-console..."
    wget https://github.com/joshdk/aws-console/releases/download/v0.3.0/aws-console-linux-amd64.tar.gz  # Download the package
    tar -xf aws-console-linux-amd64.tar.gz  # Extract the package
    sudo install aws-console /usr/bin/aws-console  # Install the binary
    rm -fr aws-console aws-console-linux-amd64.tar.gz README.md LICENSE.txt  # Clean up downloaded files
    echo "Installation completed."
}

# Check if aws-console is installed, and install it if it's not
if [ ! -f /usr/bin/aws-console ]; then
    echo "aws-console is not installed. Installing now..."
    install_aws_console
else
    echo "aws-console is already installed."
fi

# Check if AWS credentials are set
if [ ! -f ~/.aws/credentials ]; then
    echo "AWS credentials are not set. Please set the credentials in ~/.aws/credentials."
    exit 1
fi

# Validate AWS profile
profile="${2:-default}"  # Default to 'default' profile if none specified
if ! grep -q "\[$profile\]" ~/.aws/credentials; then
    echo "The specified profile '$profile' does not exist in AWS credentials."
    exit 1
fi

# Function to open AWS console in the specified browser
open_in_browser() {
    local browser=$1
    local url=$(aws-console --profile "$profile")  # Generate login URL for the specified profile
    
    # Check if the browser is installed and open the URL, else print the URL
    if [[ -x "/usr/bin/$browser" ]]; then
        echo "Opening AWS console in $browser..."
        "/usr/bin/$browser" "$url" &
    else
        echo "Browser $browser is not installed. Please open the URL manually."
        echo "URL: $url"
    fi
}

# Main execution: Check for supported browsers or default to Firefox if none specified
case $1 in
    edge|microsoft-edge|firefox|safari|chrome|google-chrome|brave|brave-browser)
        open_in_browser "$1"
        ;;
    *)
        echo "Unsupported or no browser specified. Opening in Firefox by default."
        open_in_browser "firefox"
        ;;
esac
