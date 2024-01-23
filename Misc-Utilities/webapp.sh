#!/bin/bash

# Define package URL and name for easy updating and reuse
PKG_URL="http://packages.linuxmint.com/pool/main/w/webapp-manager/webapp-manager_1.3.2_all.deb"
PKG_NAME=$(basename $PKG_URL)

# 1. Download the package using wget with -q for quiet mode and -c to continue broken downloads
wget -qc $PKG_URL

# 2. Install the package
# Using apt instead of gdebi for better dependency handling and integration with the system
sudo apt install ./$PKG_NAME -y

# 3. Remove the downloaded package
rm $PKG_NAME
