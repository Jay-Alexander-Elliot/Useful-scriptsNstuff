#!/bin/bash

# Update the package list
sudo apt update -y

# Install software-properties-common to manage repositories
sudo apt install software-properties-common -y

# Add the official Firefox PPA
sudo add-apt-repository ppa:mozillateam/firefox-next -y

# Update the package list after adding the PPA
sudo apt update -y

# Install Firefox
sudo apt install firefox -y
