#!/bin/bash
# Title: Install AnyDesk
# Description: This script automates the installation of AnyDesk on either Ubuntu/Debian or CentOS/RHEL systems. It detects the running system's distribution and executes the corresponding installation commands.
# Author: Jay-Alexander Elliot
# Usage: Execute this script with root privileges. It does not require any arguments. Usage: sudo ./this_script_name.sh

# Install AnyDesk on Ubuntu/Debian or CentOS/RHEL systems

# Function for Ubuntu/Debian systems
UB(){
    echo "Starting AnyDesk installation for Ubuntu/Debian..."
    sudo apt update -y && sudo apt upgrade -y  # Update and upgrade the system packages
    sudo apt install wget gnupg2 software-properties-common -y  # Install necessary packages
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -  # Add AnyDesk GPG key
    sudo add-apt-repository "deb http://deb.anydesk.com/ all main"  # Add AnyDesk repository
    sudo apt update  # Update the package list
    sudo apt install anydesk -y  # Install AnyDesk
    anydesk  # Launch AnyDesk
}

# Function for CentOS/RHEL systems
RH(){
    echo "Starting AnyDesk installation for CentOS/RHEL..."
    sudo tee /etc/yum.repos.d/AnyDesk.repo <<EOF  # Create AnyDesk repo file
[anydesk]
name=AnyDesk CentOS - stable
baseurl=http://rpm.anydesk.com/centos/\$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
    sudo yum makecache --refresh  # Refresh the repository cache
    sudo yum install -y redhat-lsb-core epel-release  # Install necessary packages
    sudo yum install -y anydesk  # Install AnyDesk
    rpm -qi anydesk  # Check the installation details
    anydesk  # Launch AnyDesk
}

# Check the system's distribution and execute the corresponding function
if [ -f /etc/debian_version ]; then
    echo "Distro is Ubuntu or Debian"
    UB
elif [ -f /etc/redhat-release ]; then
    echo "Distro is CentOS or RHEL"
    RH
else
    echo "Unsupported distribution. Exiting..."
    exit 1
fi
