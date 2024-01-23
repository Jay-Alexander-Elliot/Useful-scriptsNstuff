#!/bin/bash

# Define functions for Debian-based (UB) and Red Hat-based (RH) distributions
UB() {
    echo "Updating for Ubuntu/Debian..."

    #1- Download the package from GitHub
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

    #2- Install the downloaded package and fix any broken dependencies
    sudo dpkg -i cloudflared-linux-amd64.deb || sudo apt install -f
    sudo apt --fix-broken install

    #3- Update and upgrade system packages
    sudo apt update && sudo apt upgrade -y

    #4- Remove the downloaded package
    rm -f cloudflared-linux-amd64.deb

    #5- Register and connect to Cloudflare WARP
    warp-cli register && warp-cli connect

    #6- (Optional) Create your Cloudflare tunnel, uncomment if needed
    #cloudflared tunnel --url localhost:8080
}

RH() {
    echo "Updating for CentOS/RHEL..."

    #1- Download the package from GitHub
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm

    #2- Update or install the downloaded package
    sudo rpm -Uvh cloudflared-linux-x86_64.rpm || sudo yum install -y cloudflared-linux-x86_64.rpm

    #3- Remove the downloaded package
    rm -f cloudflared-linux-x86_64.rpm

    #4- (Optional) Example usage of cloudflared tunnel, uncomment if needed
    #echo "Example usage:"
    #echo "cloudflared tunnel --url http://localhost:8081/"
}

# Detect distribution and run the corresponding function
if [ -f /etc/debian_version ]; then
    UB
elif [ -f /etc/redhat-release ]; then
    RH
else
    echo "Unsupported distribution."
fi
