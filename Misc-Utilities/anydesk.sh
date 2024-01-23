#!/bin/bash
# Install AnyDesk on Ubuntu/Debian or CentOS/RHEL systems

# Function for Ubuntu/Debian systems
UB(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install wget gnupg2 software-properties-common -y
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    sudo add-apt-repository "deb http://deb.anydesk.com/ all main"
    sudo apt update
    sudo apt install anydesk -y
    anydesk
}

# Function for CentOS/RHEL systems
RH(){
    sudo tee /etc/yum.repos.d/AnyDesk.repo <<EOF
[anydesk]
name=AnyDesk CentOS - stable
baseurl=http://rpm.anydesk.com/centos/\$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
    sudo yum makecache --refresh
    sudo yum install -y redhat-lsb-core epel-release
    sudo yum install -y anydesk
    rpm -qi anydesk
    anydesk
}

# Check the system's distribution and execute the corresponding function
if [ -f /etc/debian_version ]; then
    echo "Distro is Ubuntu or Debian"
    UB
elif [ -f /etc/redhat-release ]; then
    echo "Distro is CentOS or RHEL"
    RH
fi
