#!/bin/bash

UB() {
    # Ensure the system is up to date, and you have the gnupg, software-properties-common, and curl packages
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl wget lsb-release apt-transport-https

    # Add the HashiCorp GPG key
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    # Verify the key's fingerprint
    gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

    # Add the official HashiCorp Linux repository
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    # Update and install
    sudo apt update && sudo apt-get install terraform -y
}

RH() {
    # Install yum-config-manager to manage your repositories
    sudo yum install -y yum-utils

    # Use yum-config-manager to add the official HashiCorp Linux repository
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

    # Install Terraform
    sudo yum -y install terraform

    # Verify the installation
    terraform -help
}

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
