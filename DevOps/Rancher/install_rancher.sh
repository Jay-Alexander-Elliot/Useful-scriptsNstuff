#!/usr/bin/env bash
# Title: Docker and Rancher Setup Script
# Description: This script checks for Docker installation, offers to install it if not present, and then sets up a Rancher server instance on a user-specified port.
# Author: Jay-Alexander Elliot
# Date: 2024-01-20
# Usage: Execute this script in a bash shell. The script will guide you through the process.

check_docker() {
    # Check if Docker is installed by querying the command's existence.
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is installed, moving on to the next step."
    else
        # Offer to install Docker if not found.
        while true; do
            read -p "Docker is not installed, would you like to install it? [y/n] " install_docker
            case $install_docker in
                [Yy]* )
                    # Use the official Docker installation script.
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sh get-docker.sh
                    # Break the loop after successful installation.
                    break
                    ;;
                [Nn]* )
                    echo "Please install Docker and try again."
                    exit 1
                    ;;
                * )
                    echo "Invalid input, please enter y or n."
                    ;;
            esac
        done
    fi
}

# Main function to encapsulate the logic
main() {
    # Check for Docker installation.
    check_docker

    # Prompt the user to enter the port number for the Rancher server.
    read -p "Enter port number you want to use for the Rancher server: " rancher_port

    # Run the Rancher server container with the user-specified port.
    sudo docker run -d --restart=unless-stopped -p "${rancher_port}:8080" rancher/server:stable
}

# Call the main function to execute the script.
main
