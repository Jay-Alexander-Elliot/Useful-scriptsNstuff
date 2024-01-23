#!/bin/bash

# Ensure the system is updated and that all required tools are installed.
sudo apt update && sudo apt upgrade -y
sudo apt install flatpak gnome-software-plugin-flatpak -y

# Add the Flathub repository if it doesn't already exist.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Inform the user that a restart is required for the changes to take effect.
echo "Please restart your PC to apply all changes."

# Installation of the OTPClient app from Flathub.
flatpak install flathub com.github.paolostivanin.OTPClient -y

# Instruction to run the OTPClient app.
echo "You can run the OTPClient app using the following command:"
echo "flatpak run com.github.paolostivanin.OTPClient"
