#!/usr/bin/env bash
# Title: MOTD Disabler for Ubuntu Systems
# Description: This script disables specific Message of the Day (MOTD) scripts on Ubuntu-based distributions. It checks the OS type, and if it matches Ubuntu, it proceeds to change the permissions of the designated MOTD scripts, effectively disabling them. A welcome message is displayed before the action is taken.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Execute the script with root privileges: sudo ./motd_disabler.sh

[ -r /etc/os-release ] && . /etc/os-release  # Load the os-release file to determine the distribution type

# Check if the distribution is Ubuntu, exit if not
if [[ $ID != "ubuntu" ]]; then
  echo "Script intended for Debian-like distributions only."
  exit 2
fi

# Display a welcome message with system information
printf "Welcome to %s (%s %s %s)\n" "$VERSION" "$(uname -o)" "$(uname -r)" "$(uname -m)"

# Array of MOTD scripts to be disabled
MOTD_SCRIPTS=(
  "/etc/update-motd.d/10-help-text"
  "/etc/update-motd.d/50-motd-news"
  "/etc/update-motd.d/95-hwe-eol"
)

# Iterate through the MOTD scripts and disable them by removing execute permissions
for script in "${MOTD_SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    chmod -x "$script"  # Remove execute permissions
    echo "Disabled MOTD script: $script"
  else
    echo "MOTD script not found: $script"
  fi
done
