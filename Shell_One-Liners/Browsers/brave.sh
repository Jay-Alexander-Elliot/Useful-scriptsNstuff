# Install required packages for managing repositories over HTTPS
sudo apt install apt-transport-https curl -y

# Download and add the Brave browser's GPG key
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Add the Brave browser repository
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Update the package list
sudo apt update -y

# Install the Brave browser
sudo apt install brave-browser -y
