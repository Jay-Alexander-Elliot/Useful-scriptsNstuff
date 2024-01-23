#!/bin/bash

# Function to remove none tagged images
remove_none_images() {
    images=$(docker images | grep '^<none>' | awk '{print $3}')
    if [ -n "$images" ]; then
        docker rmi -f $images
    else 
        echo "No none images"
    fi
}

# Function to remove none named containers
remove_none_containers() {
    conts=$(docker ps -a | grep '^<none>' | awk '{print $1}')
    if [ -n "$conts" ]; then
        docker rm -f $conts
    else
        echo "No none containers"
    fi
}

# Function to display help
display_help() {
    echo
    echo "Removes none images and none containers"
    echo "Usage: clean_none.sh [OPTION]"
    echo
    echo "  -l, --last      remove last image created"
    echo "  -e, --exited    remove all exited containers"
    echo "  -i, --image     remove specific image/s by id"
    echo "  -c, --container remove specific container/s by id"
    echo "  -h, --help      display this help and exit"
}

# Function to remove the last image created
remove_last_image() {
    last=$(docker images -q | head -n 1)
    if [ -n "$last" ]; then
        docker rmi -f "$last"
    else
        echo "No images to delete"
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
