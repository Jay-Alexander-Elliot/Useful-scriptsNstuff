# PowerShell script to enable or disable internet search in Windows 10 Search

# Check if the script is run with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator."
    exit
}

# Ask the user for action and make comparison case-insensitive
$userChoice = Read-Host "Enter 'disable' to turn off internet search or 'enable' to turn it back on"
$userChoice = $userChoice.ToLower()

# Ensure valid input
if ($userChoice -ne 'disable' -and $userChoice -ne 'enable') {
    Write-Host "Invalid input. Please enter either 'disable' or 'enable'."
    exit
}

# Confirmation step
$confirmation = Read-Host "Are you sure you want to $userChoice internet search? (yes/no)"
if ($confirmation -ne 'yes') {
    Write-Host "Operation cancelled by the user."
    exit
}

# Functions for enabling/disabling features
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

        Restart-Service -Name "WSearch"
        Write-Host "Internet search in Windows 10 Search has been disabled."
    } catch {
        Write-Host "An error occurred while disabling internet search: $_"
    }
}

function EnableInternetSearch {
    try {
        # Ensure registry path exists before modification
        if (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search") {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
        }

        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue

        Restart-Service -Name "WSearch"
        Write-Host "Internet search in Windows 10 Search has been enabled."
    } catch {
        Write-Host "An error occurred while enabling internet search: $_"
    }
}

# Perform action based on user choice
if ($userChoice -eq 'disable') {
    DisableInternetSearch
} else {
    EnableInternetSearch
}
