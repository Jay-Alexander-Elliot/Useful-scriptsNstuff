#!/usr/bin/env bash
# Title: File Operations Manager
# Description: This script provides a user-friendly interface to perform file operations such as compression, decompression, encryption, and decryption. It ensures necessary tools are installed and allows repetitive execution of different tasks on files or directories.
# Author: Jay-Alexander Elliot
# Date: 2024-01-20
# Usage: Run the script followed by the file or directory name as an argument. If no argument is provided, it will prompt for the file or directory name.
#        Example: ./file_operations_manager.sh [file/folder_name]

check_zip() {
    # Check if 'zip' command is available, if not, provide option to install.
    if command -v zip > /dev/null; then
        echo "Good, zip is installed. Let's move on to the next step."
        echo
    else
        while true; do
            read -p "zip is not installed, would you like to install it? [y/n] " install_zip
            case $install_zip in
                [Yy]* ) sudo apt-get install zip; break;;
                [Nn]* ) echo "Please install zip and try again."; exit 1;;
                * ) echo "Invalid input, please enter y or n.";;
            esac
        done
    fi
}

comp_decomp_encr_decr() {
    # Function for repetitive prompt for another task.
    another_task() {
        while true; do
            read -p "Do you want to do another task? [y/n] " another_task
            case $another_task in
                [Yy]* ) clear; echo "Ok, let's do another task."; echo; ls; echo; comp_decomp_encr_decr; break;;
                [Nn]* ) clear; echo "Ok, bye bye."; echo; exit 0;;
                * ) echo "Invalid input, please enter y or n."; echo;;
            esac
        done
    }

    # Function to compress files or directories.
    compress(){
        if [ -f "$name" ] || [ -d "$name" ]; then
            zip -r "$name.zip" "$name" >/dev/null
            echo "The file/folder has been compressed."
            rm -f "$name"
            name="$name.zip"
            another_task
        else
            echo "The file/folder does not exist."
        fi
    }

    # Function to decompress files.
    decompress() {
        if [ -f "$name" ] && [[ $name == *.zip ]]; then
            unzip "$name" >/dev/null
            echo "The file has been decompressed."
            rm -f "$name"
            name="${name%.zip}"
            another_task
        else
            echo "The file does not exist or is not a zip file."
        fi
    }

    # Function to encrypt files.
    encrypt(){
        if [ -f "$name" ]; then
            gpg -c "$name" >/dev/null
            echo "The file has been encrypted."
            rm -f "$name"
            name="$name.gpg"
            another_task
        else
            echo "The file does not exist."
        fi
    }

    # Function to decrypt files.
    decrypt(){
        if [ -f "$name" ] && [[ $name == *.gpg ]]; then
            name_without_extension="${name%.gpg}"
            gpg --output "$name_without_extension" --decrypt "$name"
            rm -f "$name"
            name="$name_without_extension"
            another_task
        else
            echo "The file does not exist or is not a gpg encrypted file."
        fi
    }

    # Main menu for choosing operations.
    choose() {
        while true; do
            echo "Which of the following tasks would you like to achieve?"
            echo "1- Compress $name"
            echo "2- Decompress $name"
            echo "3- Encrypt $name"
            echo "4- Decrypt $name"
            read -p "(1),(2),(3),(4): " confirm
            
            case $confirm in
                1 ) compress; break;;
                2 ) decompress; break;;
                3 ) encrypt; break;;
                4 ) decrypt; break;;
                * ) echo "Invalid input, please enter 1, 2, 3, or 4.";;
            esac
        done
    }
    choose
}

# Main script execution.
if [ -z "$1" ]; then
    read -p "Please enter the name or full path of the file/folder: " name
else
    name=$1
fi
comp_decomp_encr_decr
