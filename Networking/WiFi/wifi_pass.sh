#!/bin/bash

# Use nmcli to list available connections
echo "Available Wi-Fi networks:"
nmcli connection show | grep wifi

echo "Enter the name of the Wi-Fi network to see its password: "
read wifi_name

# Fetch the UUID of the Wi-Fi connection
uuid=$(nmcli -t -f UUID,TYPE,NAME connection show | grep wifi | grep "$wifi_name" | cut -d: -f1)

if [ -z "$uuid" ]; then
    echo "Wi-Fi network not found."
else
    # Fetch and display the password
    echo "$wifi_name Password is: "
    sudo nmcli -s connection show "$uuid" | grep 802-11-wireless-security.psk: | cut -d: -f2
fi
