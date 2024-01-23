#!/bin/bash

check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is installed, moving on to the next step."
    else
        read -p "Docker is not installed, would you like to install it? [y/n] " install_docker
        case $install_docker in
            [Yy]* )
                curl -fsSL https://get.docker.com -o get-docker.sh
                sh get-docker.sh
                ;;
            [Nn]* )
                echo "Please install Docker and try again."
                exit 1
                ;;
            * )
                echo "Invalid input, please enter y or n."
                check_docker
                ;;
        esac
    fi
}

check_docker

read -p "Enter port number you want to use for the Rancher server: " rancher_port
sudo docker run -d --restart=unless-stopped -p "${rancher_port}:8080" rancher/server:stable
