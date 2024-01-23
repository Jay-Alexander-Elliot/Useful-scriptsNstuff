#!/bin/bash

# Function to securely obtain the password
get_password() {
    # Prompt user for password and save it to a temporary file
    read -sp "Enter SSH Password: " SSH_PASS
    echo $SSH_PASS > .tmp_password.txt
    unset SSH_PASS # Clear the variable from memory
}

# Function to distribute SSH keys
distribute_keys() {
    local users=("ansible" "root") # List of users
    local operating_systems=("ubuntu" "centos") # List of operating systems
    local instances=("1" "2" "3") # List of instances

    for user in "${users[@]}"; do
        for os in "${operating_systems[@]}"; do
            for instance in "${instances[@]}"; do
                # Copy SSH key
                sshpass -f .tmp_password.txt ssh-copy-id -o StrictHostKeyChecking=no ${user}@${os}${instance}
            done
        done
    done

    # Clean up: Delete temporary password file
    rm -f .tmp_password.txt
}

# Main script execution
get_password
distribute_keys
