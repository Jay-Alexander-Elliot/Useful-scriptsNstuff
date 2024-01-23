#!/bin/bash

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to uninstall minikube
uninstall_minikube() {
    minikube stop; minikube delete
    docker stop $(docker ps -aq)
    rm -rf ~/.kube ~/.minikube
    sudo rm /usr/local/bin/localkube /usr/local/bin/minikube
    systemctl stop '*kubelet*.mount'
    sudo rm -rf /etc/kubernetes/
    docker system prune -af --volumes
    clear
    echo "Previous minikube version uninstalled"
    echo
}

# Uninstall minikube if it exists and the user agrees
if command_exists minikube; then
    echo "minikube is already installed"
    read -p "Do you want to uninstall minikube? (y/n) " check_ans
    if [ "$check_ans" = "y" ]; then
        uninstall_minikube
    else
        echo "Skipping uninstallation of previous minikube version"
        exit
    fi
fi

# Install Docker if it's not installed
if ! command_exists docker; then
    echo "Docker is not installed"
    read -p "Do you want to install Docker? (y/n) " check_ans
    if [ "$check_ans" = "y" ]; then
        curl -fsSL https://get.docker.com | sh
    else
        echo "You need to install Docker first"
        exit
    fi
fi

# Ask the user if they want to use VirtualBox or Docker and store the choice in vb_or_docker
read -p "Do you want to use VirtualBox or Docker as a Minikube driver? (vb/d) " vb_or_docker

# Function to install minikube for Ubuntu or Debian based systems
install_minikube_debian() {
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt-get install -y curl
    wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo rm minikube-linux-amd64
}

# Function to install minikube for RedHat based systems
install_minikube_redhat() {
    sudo yum update -y && sudo yum upgrade -y
    sudo yum install -y curl
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
    sudo rpm -Uvh minikube-latest.x86_64.rpm
    sudo rm -f minikube-latest.x86_64.rpm
}

# Install Minikube based on the Linux Distribution
if [ -f /etc/debian_version ]; then
    echo "Distro is Ubuntu or Debian"
    install_minikube_debian
elif [ -f /etc/redhat-release ]; then
    echo "Distro is CentOS or RHEL"
    install_minikube_redhat
fi

# Check the version of Minikube and install kubectl
minikube version
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Function to install VirtualBox
install_virtualbox() {
    if [ -f /etc/debian_version ]; then
        sudo apt-get install -y virtualbox virtualbox-ext-pack
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y kernel-devel kernel-devel-$(uname -r) kernel-headers kernel-headers-$(uname -r) make patch gcc
        sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
        sudo yum install -y VirtualBox-6.1
    fi
}

# Decide to use VirtualBox or Docker and start Minikube
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
        echo "Invalid choice, defaulting to Docker"
        minikube config set driver docker
        minikube start --driver=docker
        ;;
esac
