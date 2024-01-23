#!/bin/bash

# Check if the necessary number of arguments are provided
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <users> <os_list> <instance_numbers>"
    echo "Example: $0 'ansible root' 'ubuntu centos' '1 2 3'"
    exit 1
fi

# Extract the arguments into readable variables
USERS="$1"
OS_LIST="$2"
INSTANCE_NUMBERS="$3"

# Password file path
PASSWORD_FILE="password.txt"

# Loop to distribute SSH keys
for user in $USERS; do
    for os in $OS_LIST; do
        for instance in $INSTANCE_NUMBERS; do
            # Use sshpass to automate SSH password authentication
            # ssh-copy-id copies the local public key to the remote machine's authorized_keys
            # StrictHostKeyChecking=no skips the host key verification for first-time connections
            sshpass -f $PASSWORD_FILE ssh-copy-id -o StrictHostKeyChecking=no ${user}@${os}${instance}
        done
    done
done
