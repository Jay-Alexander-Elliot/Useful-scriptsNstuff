#!/bin/bash

# This script creates a URL to log in to an AWS account using the .aws/credentials.
# It checks if aws-console tool is installed and if the credentials are set.

# Function to install aws-console
install_aws_console() {
    # Download the PKG
    wget https://github.com/joshdk/aws-console/releases/download/v0.3.0/aws-console-linux-amd64.tar.gz
    # Untar it
    tar -xf aws-console-linux-amd64.tar.gz
    # Install it in /usr/bin
    sudo install aws-console /usr/bin/aws-console
    # Clean up
    rm -fr aws-console aws-console-linux-amd64.tar.gz README.md LICENSE.txt
}

# Check if aws-console is installed
if [ ! -f /usr/bin/aws-console ]; then
    echo "aws-console is not installed"
    install_aws_console
    echo "aws-console has been installed in /usr/bin/aws-console"
fi

# Check if AWS credentials are set
if [ ! -f ~/.aws/credentials ]; then
    echo "Credentials are not set. Please set the credentials first."
    exit 1
fi

# Check if the profile is passed and valid
profile="${2:-default}" # Use default profile if not specified
if ! grep -q "\[$profile\]" ~/.aws/credentials; then
    echo "Profile $profile does not exist."
    exit 1
fi

# Function to open URL in browser
open_in_browser() {
    local browser=$1
    local url=$(aws-console --profile "$profile")
    
    if [[ -x "/usr/bin/$browser" ]]; then
        "/usr/bin/$browser" "$url" &
    else
        echo "Browser $browser is not installed."
        echo "URL: $url"
    fi
}

# Main execution
case $1 in
    edge|microsoft-edge|firefox|safari|chrome|google-chrome|brave|brave-browser)
        open_in_browser "$1"
        ;;
    *)
        echo "No browser or profile was passed. Opening in default browser."
        open_in_browser "firefox"
        ;;
esac
