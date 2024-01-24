#!/usr/bin/env bash
# Title: Minikube Setup and Management Script
# Description: This script manages the installation, uninstallation, and setup of Minikube and its dependencies like Docker and VirtualBox. It's compatible with Debian and RedHat based distributions.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Run this script with root privileges. Answer the prompts to install or uninstall Minikube, Docker, and choose between VirtualBox and Docker as the Minikube driver.

# Exit on any error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to uninstall minikube
uninstall_minikube() {
    echo "Uninstalling minikube..."
    minikube stop; minikube delete
    docker stop $(docker ps -aq)
    rm -rf ~/.kube ~/.minikube
    sudo rm /usr/local/bin/localkube /usr/local/bin/minikube
    systemctl stop '*kubelet*.mount'
    sudo rm -rf /etc/kubernetes/
    docker system prune -af --volumes
    echo "Minikube and related resources were removed."
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    echo "Docker installed successfully."
}

# Function to install minikube for Debian-based systems
install_minikube_debian() {
    echo "Installing minikube on Debian-based system..."
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt-get install -y curl
    wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm minikube-linux-amd64
    echo "Minikube installed successfully."
}

# Function to install minikube for RedHat-based systems
install_minikube_redhat() {
    echo "Installing minikube on RedHat-based system..."
    sudo yum update -y && sudo yum upgrade -y
    sudo yum install -y curl
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
    sudo rpm -Uvh minikube-latest.x86_64.rpm
    sudo rm -f minikube-latest.x86_64.rpm
    echo "Minikube installed successfully."
}

# Function to install VirtualBox
install_virtualbox() {
    echo "Installing VirtualBox..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get install -y virtualbox virtualbox-ext-pack
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y kernel-devel kernel-devel-$(uname -r) kernel-headers kernel-headers-$(uname -r) make patch gcc
        sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
        sudo yum install -y VirtualBox-6.1
    fi
    echo "VirtualBox installed successfully."
}

# Main logic
if command_exists minikube; then
    echo "Minikube is already installed."
    read -p "Do you want to uninstall minikube? (y/n) " check_ans
    if [ "$check_ans" = "y" ]; then
        uninstall_minikube
    else
        echo "Skipping uninstallation of minikube."
        exit
    fi
fi

if ! command_exists docker; then
    echo "Docker is not installed."
    read -p "Do you want to install Docker? (y/n) " check_ans
    if [ "$check_ans" = "y" ]; then
        install_docker
    else
        echo "You need to install Docker first."
        exit
    fi
fi

read -p "Do you want to use VirtualBox or Docker as a Minikube driver? (vb/d) " vb_or_docker

if [ -f /etc/debian_version ]; then
    install_minikube_debian
elif [ -f /etc/redhat-release ]; then
    install_minikube_redhat
fi

minikube version
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

case $vb_or_docker in
    vb)
        install_virtualbox
        minikube config set driver virtualbox
        minikube start --driver=virtualbox
        ;;
    d)
        minikube config set driver docker
        minikube start --driver=docker
        ;;
    *)
        echo "Invalid choice, defaulting to Docker."
        minikube config set driver docker
        minikube start --driver=docker
        ;;
esac

echo "Minikube setup is complete."
