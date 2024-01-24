#!/usr/bin/env bash
# Title: Package Installer for Linux Mint
# Description: This script automates the process of downloading and installing a specific software package for Linux Mint. It handles the download, installation, and clean-up stages.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Execute this script with sufficient permissions. Usage: ./package_installer.sh

set -euo pipefail  # Bash strict mode, exits on error, unbound variables, or pipefail

# Define package URL and name for easy updating and reuse
PKG_URL="http://packages.linuxmint.com/pool/main/w/webapp-manager/webapp-manager_1.3.2_all.deb"
PKG_NAME=$(basename "$PKG_URL")

echo "Starting the installation process for $PKG_NAME..."

# 1. Download the package using wget with -q for quiet mode and -c to continue broken downloads
if wget -qc "$PKG_URL"; then
    echo "$PKG_NAME downloaded successfully."
else
    echo "Error: Failed to download $PKG_NAME. Please check the URL or your internet connection."
    exit 1
fi

# 2. Install the package
# Using apt instead of gdebi for better dependency handling and integration with the system
if sudo apt install "./$PKG_NAME" -y; then
    echo "$PKG_NAME installed successfully."
else
    echo "Error: Failed to install $PKG_NAME. Please check your permissions or package dependencies."
    exit 1
fi

# 3. Remove the downloaded package
if rm "$PKG_NAME"; then
    echo "$PKG_NAME removed after installation."
else
    echo "Warning: Failed to remove $PKG_NAME. Manual removal might be necessary."
fi

echo "Package installation process completed."
