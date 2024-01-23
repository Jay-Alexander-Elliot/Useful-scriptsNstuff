#!/bin/bash

# Prompt user for confirmation before proceeding
read -p "This script will install yt-dlp and its dependencies. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Installation aborted by the user."
    exit 1
fi

# Step 1: Remove existing yt-dlp package if it's already installed (optional)
echo "Checking and removing any existing versions of yt-dlp..."
if command -v yt-dlp >/dev/null 2>&1; then
    sudo apt remove yt-dlp -y
fi
if pip list | grep -F youtube-dl >/dev/null 2>&1; then
    sudo -H pip uninstall youtube-dl -y
fi

# Step 2: Download the latest yt-dlp binary from GitHub
# Ensure destination directory exists
if [ ! -d "$HOME/.local/bin" ]; then
    echo "Creating destination directory..."
    mkdir -p "$HOME/.local/bin"
fi

echo "Downloading yt-dlp..."
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$HOME/.local/bin/yt-dlp"
if [ $? -ne 0 ]; then
    echo "Download failed. Exiting."
    exit 1
fi

# Optional: Add a checksum verification step here

# Step 3: Make the downloaded binary executable
echo "Setting executable permissions for yt-dlp..."
chmod a+rx "$HOME/.local/bin/yt-dlp"

# Step 4: Check if ~/.local/bin is in your PATH
echo "Updating PATH..."
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
    echo "Please restart your terminal or source your ~/.bashrc to update the PATH."
fi

# Step 5: Install FFmpeg, a crucial dependency for yt-dlp
echo "Installing FFmpeg..."
sudo apt install ffmpeg -y

# Step 6: Check for Python 3.8+ and install if necessary
echo "Checking Python version..."
PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '(?<=Python )\d+\.\d+')
REQUIRED_PYTHON="3.8"
if [[ $(echo "$PYTHON_VERSION < $REQUIRED_PYTHON" | bc) -eq 1 ]]; then
    echo "Installing Python 3.8..."
    sudo apt install python3.8 -y
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
else
    echo "Compatible Python version ($PYTHON_VERSION) already installed."
fi

echo "yt-dlp installation and setup complete."
