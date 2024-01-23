#!/bin/bash
# This script installs Free Download Manager (FDM) on Debian-based distros.

# Define the location for the download and the name of the package.
DOWNLOAD_DIR="/home/$USER/Downloads"
PACKAGE_NAME="freedownloadmanager.deb"
PACKAGE_URL="https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb"

# Navigate to the download directory.
cd $DOWNLOAD_DIR

# Download the latest version of FDM using wget.
wget -O $PACKAGE_NAME $PACKAGE_URL

# Install the downloaded package using dpkg.
sudo dpkg -i $PACKAGE_NAME

# In case of missing dependencies, fix them.
sudo apt-get install -f

# Clean up by removing the downloaded package.
rm -f $PACKAGE_NAME

# Navigate back to the previous directory.
cd -
