#!/usr/bin/env bash
# Title: GNOME Shell and Clipboard Indicator Installation
# Description: This script provides a step-by-step guide to install the GNOME Shell integration browser extension, the GNOME Shell host connector, and the Clipboard Indicator extension. It also includes troubleshooting steps for potential issues.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Follow the instructions sequentially. Execute bash commands in the terminal. For browser steps, follow the provided URLs.

# Step 1: Install the GNOME Shell integration browser extension
# This extension allows you to manage GNOME Shell extensions through your browser.
# Instructions:
# 1.1 Visit the URL below and add the extension to your browser.
# URL: https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep

# Step 2: Install the GNOME Shell host connector
# This connector allows the browser extension to communicate with GNOME Shell.
# Instructions:
# 2.1 Update your package list.
# 2.2 Install the 'chrome-gnome-shell' package which acts as the host connector.
sudo apt update && sudo apt install chrome-gnome-shell

# Step 3: Install the Clipboard Indicator extension
# This GNOME Shell extension adds a clipboard manager to the top panel.
# Instructions:
# 3.1 Open the link below and toggle on the Clipboard Indicator.
# URL: https://extensions.gnome.org/extension/779/clipboard-indicator/

# Troubleshooting Steps:
# If you encounter issues, try these steps one at a time.
# T1: Clear your browser's cache and cookies, then restart the browser.
# T2: Ensure the GNOME Shell integration extension is enabled in your browser's extension settings.
# T3: Restart your GNOME Shell without logging out or rebooting by pressing Alt+F2, typing 'r', and pressing Enter.
# T4: If the problem persists, restart your machine.
# T5: Try using a different browser (Firefox, Edge, or Brave) to see if the issue is browser-specific.
# Note: For browsers like Firefox, you may need a different host connector. Use your package manager to search for and install the appropriate package, e.g., 'firefox-gnome-shell'.

# End of script
