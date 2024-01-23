#!/bin/bash

# Update package lists to ensure the package versions and dependencies are up to date
sudo apt-get update

# Install bash-completion if it's not already installed
if ! dpkg -s bash-completion >/dev/null 2>&1; then
  sudo apt-get install -y bash-completion
fi

# Install kubectl if it's not already installed, updating it to the latest version if it is
if ! type kubectl >/dev/null 2>&1; then
  sudo apt-get install -y apt-transport-https gnupg2
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

# Append bash completion script to .bashrc if it's not already included
BASHRC=~/.bashrc
if ! grep -q 'source <(kubectl completion bash)' "$BASHRC"; then
  echo "source <(kubectl completion bash)" >> "$BASHRC"
fi

# Reload .bashrc to apply changes immediately without needing a re-login
source ~/.bashrc
