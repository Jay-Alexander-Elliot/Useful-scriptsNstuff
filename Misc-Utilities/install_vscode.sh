#!/bin/bash

# Function to install Visual Studio Code on Ubuntu/Debian-based distributions
UB(){
    # Install HTTPS transport for APT and import Microsoft GPG key
    sudo apt-get install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null

    # Add the Visual Studio Code repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

    # Update the package list and install Visual Studio Code
    sudo apt update
    sudo apt install -y code # or code-insiders
}

# Function to install Visual Studio Code on Red Hat-based distributions
RH(){
    # Import Microsoft GPG key
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    # Add the Visual Studio Code repository
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Install Visual Studio Code
    sudo yum install -y code # or code-insiders
}

# Detect the distribution and call the respective function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        debian|ubuntu) UB ;;
        rhel|centos|fedora) RH ;;
        *) echo "Unsupported distribution: $ID" ;;
    esac
else
    echo "Cannot detect the distribution!"
fi
