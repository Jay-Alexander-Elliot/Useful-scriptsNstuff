#!/usr/bin/env bash
# Title: InstallFDM.sh
# Description: This script automates the installation of Free Download Manager (FDM) on Debian-based distributions. It handles downloading, installing, and cleaning up the installation package.
# Author: Jay-Alexander Elliot
# Date: 2024-01-20
# Usage: Run the script with sudo privileges: `sudo bash InstallFDM.sh`

function install_fdm() {
    # Define the location for the download and the name of the package.
    local download_dir="/home/$USER/Downloads"
    local package_name="freedownloadmanager.deb"
    local package_url="https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb"

    # Ensure the download directory exists.
    mkdir -p "$download_dir"

    # Navigate to the download directory.
    cd "$download_dir" || { echo "Failed to navigate to the download directory."; exit 1; }

    # Download the latest version of FDM using wget.
    echo "Downloading Free Download Manager..."
    wget -O "$package_name" "$package_url" || { echo "Failed to download the package."; exit 1; }

    # Install the downloaded package using dpkg.
    echo "Installing Free Download Manager..."
    sudo dpkg -i "$package_name" || { echo "Installation failed. Attempting to resolve dependencies..."; sudo apt-get install -f; }

    # Clean up by removing the downloaded package.
    echo "Cleaning up the installation files..."
    rm -f "$package_name"

    # Navigate back to the previous directory.
    cd - || exit
}

# Check if the user has sudo privileges.
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run it as root or with sudo."
    exit 1
fi

# Call the installation function.
install_fdm

echo "Free Download Manager installation completed successfully."
