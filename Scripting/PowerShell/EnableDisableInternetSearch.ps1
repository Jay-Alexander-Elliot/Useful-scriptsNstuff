#!/usr/bin/env pwsh
# Title: Toggle Windows 10 Internet Search
# Description: This PowerShell script enables or disables the internet search feature in Windows 10 Search. It modifies registry settings and requires administrative privileges.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Run this script in a PowerShell environment with administrative privileges. Enter 'disable' to turn off internet search or 'enable' to turn it back on.

# Check if the script is run with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator."
    exit
}

# Get user input for action and make comparison case-insensitive
$userChoice = Read-Host "Enter 'disable' to turn off internet search or 'enable' to turn it back on"
$userChoice = $userChoice.ToLower()

# Ensure valid input
if ($userChoice -ne 'disable' -and $userChoice -ne 'enable') {
    Write-Host "Invalid input. Please enter either 'disable' or 'enable'."
    exit
}

# Confirm user's intention before proceeding
$confirmation = Read-Host "Are you sure you want to $userChoice internet search? (yes/no)"
if ($confirmation -ne 'yes') {
    Write-Host "Operation cancelled by the user."
    exit
}

# Function to disable internet search
function DisableInternetSearch {
    try {
        # Ensure registry path exists before modification
        if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search") {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0
        }

        # Create key if it does not exist
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Value 1

        # Restart the search service to apply changes
        Restart-Service -Name "WSearch"
        Write-Host "Internet search in Windows 10 Search has been disabled."
    } catch {
        Write-Host "An error occurred while disabling internet search: $_"
    }
}

# Function to enable internet search
function EnableInternetSearch {
    try {
        # Ensure registry path exists before modification
        if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search") {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
        }

        # Remove key to enable web search
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue

        # Restart the search service to apply changes
        Restart-Service -Name "WSearch"
        Write-Host "Internet search in Windows 10 Search has been enabled."
    } catch {
        Write-Host "An error occurred while enabling internet search: $_"
    }
}

# Execute appropriate function based on user choice
if ($userChoice -eq 'disable') {
    DisableInternetSearch
} else {
    EnableInternetSearch
}
