#!/usr/bin/env bash
# Title: Install Docker Script
# Description: This script installs Docker on Ubuntu-based (Debian) or RHEL-based (CentOS) distributions. It removes old versions, sets up the repository, installs Docker, and starts the Docker service. It also adds the current user to the Docker group.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Run this script with root privileges. No arguments are required. Usage example: sudo ./install_docker.sh

# Function to install Docker on Ubuntu-based distributions
UB() {
    echo "Starting Docker installation for Ubuntu or Debian..."
    
    # Remove any old versions of Docker
    echo "Removing old versions of Docker..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo apt-get autoremove -y --purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Set up the repository
    echo "Setting up the Docker repository..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Add the Docker repository to the APT sources
    echo "Adding the Docker repository..."
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    echo "Installing Docker Engine..."
    sudo apt-get update
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Function to install Docker on RHEL-based distributions
RH() {
    echo "Starting Docker installation for CentOS or RHEL..."
    
    # Remove any old versions of Docker
    echo "Removing old versions of Docker..."
    sudo yum remove -y docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-engine

    # Set up the repository
    echo "Setting up the Docker repository..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Install Docker Engine
    echo "Installing Docker Engine..."
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Check the distribution and call the respective function
echo "Checking the distribution..."
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

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Wait for Docker service to stabilize
echo "Waiting for Docker service to stabilize..."
sleep 5

# Check if Docker is running
echo "Checking Docker service status..."
if systemctl is-active --quiet docker; then
    echo "Docker is up & running :)"
    echo "Try running 'docker ps' to check if it's working"
else
    echo "Docker service is not running. Attempting to restart..."
    sudo systemctl restart docker
    sleep 5
    if systemctl is-active --quiet docker; then
        echo "Docker is now up & running :)"
    else
        echo "Docker failed to start. Please investigate the issue."
    fi
fi

# Add the current user to the Docker group
echo "Adding the current user to the Docker group..."
sudo usermod -aG docker $USER && newgrp docker
