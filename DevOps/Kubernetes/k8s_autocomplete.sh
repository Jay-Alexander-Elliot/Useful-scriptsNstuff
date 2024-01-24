#!/usr/bin/env bash
# Title: Kubernetes Setup and Bash Completion
# Description: This script ensures that the system's package lists are updated, installs bash-completion if it's not already installed, and sets up kubectl (a command-line interface for Kubernetes). It also configures bash completion for kubectl by appending the necessary script to .bashrc.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Run this script with root privileges. Use `sudo ./<script_name>.sh`.

# Update package lists to ensure the versions and dependencies of packages are current.
sudo apt-get update

# Install bash-completion if it's not already installed, providing a more fluid command-line experience.
if ! dpkg -s bash-completion >/dev/null 2>&1; then
  sudo apt-get install -y bash-completion
fi

# Install kubectl if it's not already installed. kubectl is a command-line tool for controlling Kubernetes clusters.
# If it's already installed, this section ensures it's updated to the latest version.
if ! type kubectl >/dev/null 2>&1; then
  # Install prerequisites for kubectl.
  sudo apt-get install -y apt-transport-https gnupg2
  # Add the Google Cloud public signing key.
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  # Add the Kubernetes apt repository.
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  # Update the package list and install the kubectl package.
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

# Append bash completion script to .bashrc if it's not already included, to enable command auto-completion for kubectl.
BASHRC=~/.bashrc
if ! grep -q 'source <(kubectl completion bash)' "$BASHRC"; then
  echo "source <(kubectl completion bash)" >> "$BASHRC"
fi

# Reload .bashrc to apply changes immediately without needing a re-login. This enables the use of kubectl with bash completion straight away.
source ~/.bashrc
