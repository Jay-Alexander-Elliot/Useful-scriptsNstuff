#!/usr/bin/env bash
# Title: Cloudflared Installation and Setup
# Description: This script automates the installation and basic setup of Cloudflare's cloudflared tool on Debian-based (like Ubuntu) and Red Hat-based (like CentOS) Linux distributions. It includes functions for each distribution type and handles package downloads, installations, and basic Cloudflare WARP registration and tunnel creation.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Execute this script with root privileges. It will auto-detect your Linux distribution and perform the installation. Ensure you have internet connectivity and wget installed.

# Define function for Debian-based distributions (like Ubuntu)
UB() {
    echo "Updating for Ubuntu/Debian..."

    # Download the cloudflared package from GitHub
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

    # Install the downloaded package and fix any broken dependencies
    sudo dpkg -i cloudflared-linux-amd64.deb || sudo apt-get install -f
    sudo apt-get --fix-broken install

    # Update and upgrade system packages
    sudo apt-get update && sudo apt-get upgrade -y

    # Remove the downloaded package to clean up
    rm -f cloudflared-linux-amd64.deb

    # Register and connect to Cloudflare WARP
    warp-cli register && warp-cli connect

    # (Optional) Create your Cloudflare tunnel, uncomment if needed
    #cloudflared tunnel --url localhost:8080
}

# Define function for Red Hat-based distributions (like CentOS)
RH() {
    echo "Updating for CentOS/RHEL..."

    # Download the cloudflared package from GitHub
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm

    # Update or install the downloaded package
    sudo rpm -Uvh cloudflared-linux-x86_64.rpm || sudo yum install -y cloudflared-linux-x86_64.rpm

    # Remove the downloaded package to clean up
    rm -f cloudflared-linux-x86_64.rpm

    # (Optional) Provide an example usage of cloudflared tunnel, uncomment if needed
    #echo "Example usage:"
    #echo "cloudflared tunnel --url http://localhost:8081/"
}

# Detect the Linux distribution and run the corresponding function
if [ -f /etc/debian_version ]; then
    UB
elif [ -f /etc/redhat-release ]; then
    RH
else
    echo "Unsupported distribution."
fi
