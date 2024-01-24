#!/usr/bin/env bash
# Title: Setup Flatpak and Install OTPClient
# Description: This script updates the system, installs Flatpak with the GNOME plugin, adds the Flathub repository, and installs the OTPClient application from Flathub. It ensures that the system is ready for Flatpak applications and specifically sets up OTPClient for managing One-Time Passwords (OTPs).
# Author: Jay-Alexander Elliot
# Date: 2024-01-20
# Usage: Execute this script with administrative privileges. You can run this script by saving it to a file and executing 'sudo bash filename.sh'.

# Ensure the system is updated and that all required tools are installed.
# This step updates the package lists, upgrades the packages, and installs Flatpak along with the GNOME plugin for software management.
sudo apt update && sudo apt upgrade -y
sudo apt install flatpak gnome-software-plugin-flatpak -y

# Add the Flathub repository if it doesn't already exist.
# Flathub is the main repository for distributing applications in Flatpak format.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Inform the user that a restart might be required for the changes to take effect fully.
echo "Please restart your PC to ensure all changes are properly applied."

# Installation of the OTPClient app from Flathub.
# OTPClient is a highly secure and easy-to-use app for managing TOTP and HOTP tokens.
flatpak install flathub com.github.paolostivanin.OTPClient -y

# Instruction to run the OTPClient app.
# Provides the user with the command to launch OTPClient after installation.
echo "You can run the OTPClient app using the following command:"
echo "flatpak run com.github.paolostivanin.OTPClient"

