#!/usr/bin/env bash
# Title: Automated Visual Studio Code Installer
# Description: This script automates the installation of Visual Studio Code for Ubuntu/Debian-based and Red Hat-based Linux distributions. It handles the addition of Microsoft's GPG key, configures the repository, and installs the Visual Studio Code package.
# Author: Jay-Alexander Elliot
# Date: 2024-01-20
# Usage: Run this script with root privileges. Usage: sudo ./this_script.sh

# Function to install Visual Studio Code on Ubuntu/Debian-based distributions
UB(){
    echo "Starting installation for Ubuntu/Debian-based distributions..."
    # Install required packages to handle HTTPS sources in APT
    sudo apt-get install -y wget gpg apt-transport-https

    # Import Microsoft GPG key and add it to the trusted keys
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null

    # Add the Visual Studio Code repository to APT sources
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

    # Update the APT package list and install Visual Studio Code
    sudo apt update
    sudo apt install -y code # or code-insiders for the latest features
    echo "Visual Studio Code installation completed for Ubuntu/Debian-based distributions."
}

# Function to install Visual Studio Code on Red Hat-based distributions
RH(){
    echo "Starting installation for Red Hat-based distributions..."
    # Import Microsoft GPG key
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    # Add the Visual Studio Code repository to YUM sources
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Install Visual Studio Code
    sudo yum install -y code # or code-insiders for the latest features
    echo "Visual Studio Code installation completed for Red Hat-based distributions."
}

# Detect the Linux distribution and call the respective function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        debian|ubuntu) UB ;;
        rhel|centos|fedora) RH ;;
        *) echo "Unsupported distribution: $ID. This script supports Ubuntu/Debian-based and Red Hat-based distributions." ;;
    esac
else
    echo "Cannot detect the distribution! Ensure the /etc/os-release file exists."
fi
