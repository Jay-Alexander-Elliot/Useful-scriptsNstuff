#!/bin/bash

# Navigate to Downloads directory
cd /home/$USER/Downloads

# Download Google Chrome .deb package
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Install the .deb package using apt (modern approach)
sudo apt install ./google-chrome-stable_current_amd64.deb

# Remove the downloaded .deb file
rm -f google-chrome-stable_current_amd64.deb

# Return to the previous directory (optional)
cd -
