#!/usr/bin/env bash
# Title: Helm Installation and Update Script
# Description: This script checks for an existing Helm installation, offers to uninstall the previous version, and installs the latest Helm 3. 
#              It ensures that users are prompted before uninstallation and informed throughout the process.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Execute this script with admin privileges to manage Helm installation. Usage: ./this_script_name.sh

# Function to ask for user consent before uninstalling Helm
ask_before_uninstall() {
    while true; do
        read -p "Do you want to uninstall helm? (y/n) " check_ans
        case $check_ans in
            [Yy]* )
                sudo rm -f /usr/local/bin/helm
                echo -e "\nPrevious Helm version uninstalled.\n"
                break;;
            [Nn]* )
                echo -e "\nUninstallation of previous Helm version skipped."
                exit;;
            * )
                echo -e "\nInvalid input, please enter 'y' for yes or 'n' for no.\n";;
        esac
    done
}

# Function to install Helm
install_helm() {
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    if [ ! -f get_helm.sh ]; then
        echo -e "\nFailed to download get_helm.sh. Check your internet connection or the directory permissions.\n"
        exit 1
    else
        chmod +x get_helm.sh
        ./get_helm.sh
        echo -e "\nHelm 3 installed successfully.\n"
        rm -f get_helm.sh
    fi
}

# Function to check if Helm is already installed
check_helm() {
    if [ -x "$(command -v helm)" ]; then
        echo -e "\nHelm is already installed.\n"
        ask_before_uninstall
        install_helm
    else
        echo -e "\nNo previous Helm installation detected. Proceeding with the installation.\n"
        install_helm
    fi
}

# Starting the script by checking if Helm is installed
check_helm
