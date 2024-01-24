#!/usr/bin/env bash
# Title: Terraform Installer
# Description: This script automates the installation of Terraform on Linux distributions. It detects the distribution type and installs Terraform using the appropriate package manager and repository.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Run this script with root privileges. Usage: sudo ./terraform_installer.sh

UB() {
    # Update system packages and install dependencies
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl wget lsb-release apt-transport-https

    # Add the HashiCorp GPG key
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    # Verify the GPG key's fingerprint for security
    gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

    # Add the official HashiCorp Linux repository
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    # Update package lists and install Terraform
    sudo apt update && sudo apt-get install terraform -y
}

RH() {
    # Install yum-config-manager to manage repositories
    sudo yum install -y yum-utils

    # Add the official HashiCorp Linux repository
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

    # Install Terraform
    sudo yum -y install terraform

    # Verify the installation
    terraform -help
}

# Check the Linux distribution and call the appropriate function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            echo "Distro is Ubuntu or Debian"
            UB
            ;;
        centos|rhel)
            echo "Distro is CentOS or RHEL"
            RH
            ;;
        *)
            echo "Unsupported distribution: $ID"
            ;;
    esac
else
    echo "Cannot determine the distribution type"
fi
