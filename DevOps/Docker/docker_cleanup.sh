#!/usr/bin/env bash
# Title: Docker Cleanup Utility
# Description: This script provides a set of functions to manage Docker images and containers. It allows the removal of <none> tagged images, <none> named containers, last created images, all exited containers, and specific images or containers by ID.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: ./docker_cleanup_utility.sh [OPTION] [ARGUMENTS...]
# Options:
#   -l, --last      Remove the last image created.
#   -e, --exited    Remove all exited containers.
#   -i, --image     Remove specific image/s by ID. IDs should be passed as additional arguments.
#   -c, --container Remove specific container/s by ID. IDs should be passed as additional arguments.
#   -h, --help      Display this help and exit.

# Function to remove none tagged images
remove_none_images() {
    images=$(docker images | grep '<none>' | awk '{print $3}')
    if [ -n "$images" ]; then
        docker rmi -f $images
    else 
        echo "No none-tagged images to remove."
    fi
}

# Function to remove none named containers
remove_none_containers() {
    conts=$(docker ps -a | grep '<none>' | awk '{print $1}')
    if [ -n "$conts" ]; then
        docker rm -f $conts
    else
        echo "No none-named containers to remove."
    fi
}

# Function to display help
display_help() {
    echo
    echo "Removes <none> tagged images and <none> named containers among other utilities."
    echo "Usage: ./docker_cleanup_utility.sh [OPTION] [ARGUMENTS...]"
    echo
    echo "  -l, --last      Remove the last image created."
    echo "  -e, --exited    Remove all exited containers."
    echo "  -i, --image     Remove specific image/s by ID. IDs should be passed as additional arguments."
    echo "  -c, --container Remove specific container/s by ID. IDs should be passed as additional arguments."
    echo "  -h, --help      Display this help and exit."
}

# Function to remove the last image created
remove_last_image() {
    last=$(docker images -q | head -n 1)
    if [ -n "$last" ]; then
        docker rmi -f "$last"
    else
        echo "No images to delete."
    fi
}

# Function to remove all exited containers
remove_exited_containers() {
    docker container prune -f
}

# Function to remove specific images by id
remove_specific_images() {
    docker rmi -f "${@:2}"
}

# Function to remove specific containers by id
remove_specific_containers() {
    docker rm -f "${@:2}"
}

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Docker could not be found, please install Docker."
    exit 1
fi

# Main program
args=("$@")
if [ -z "${1}" ] || [ "${1}" == '-h' ] || [ "${1}" == '--help' ]; then
    display_help
else
    case "${1}" in
        -l|--last)
            remove_last_image
            ;;
        -e|--exited)
            remove_exited_containers
            ;;
        -i|--image)
            remove_specific_images "${args[@]}"
            ;;
        -c|--container)
            remove_specific_containers "${args[@]}"
            ;;
        *)
            echo "Invalid option: ${1}"
            display_help
            ;;
    esac
fi
