#!/bin/bash

# Function to install Docker on Ubuntu-based distributions
UB(){
    # Remove any old versions of Docker
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo apt-get autoremove -y --purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Set up the repository
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Add the Docker repository to the APT sources
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Function to install Docker on RHEL-based distributions
RH(){
    # Remove any old versions of Docker
    sudo yum remove -y docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-engine

    # Set up the repository
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Install Docker Engine
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Check the distribution and call the respective function
if [ -f /etc/debian_version ]; then
    echo "Distro is Ubuntu or Debian"
    UB
elif [ -f /etc/redhat-release ]; then
    echo "Distro is CentOS or RHEL"
    RH
fi

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Wait for Docker service to stabilize
sleep 5

# Check if Docker is running
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
sudo usermod -aG docker $USER && newgrp docker
