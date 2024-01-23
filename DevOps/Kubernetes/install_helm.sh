#!/bin/bash

# Function to ask for user consent before uninstalling Helm
ask_before_uninstall() {
    while true; do
        read -p "Do you want to uninstall helm? (y/n) " check_ans
        case $check_ans in
            [Yy]* )
                sudo rm -f /usr/local/bin/helm
                echo -e "\nPrevious helm version uninstalled\n"
                break;;
            [Nn]* )
                echo -e "\nSkipping uninstallation of previous helm version"
                exit;;
            * )
                echo -e "\nInvalid input, please enter y or n\n";;
        esac
    done
}

# Function to install Helm
install_helm() {
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    if [ ! -f get_helm.sh ]; then
        echo -e "\nget_helm.sh not downloaded. Check your internet connection or the directory where it's downloaded\n"
        exit 1
    else
        chmod +x get_helm.sh
        ./get_helm.sh
        rm -f get_helm.sh
    fi
}

# Function to check if Helm is already installed
check_helm() {
    if [ -x "$(command -v helm)" ]; then
        echo -e "\nHelm is already installed\n"
        ask_before_uninstall
        install_helm
    else
        install_helm
    fi
}

check_helm
