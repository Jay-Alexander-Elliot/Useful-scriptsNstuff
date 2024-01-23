#!/bin/bash

# Array of filenames
files=("PLaceholder")

# Loop through each file name
for file in "${files[@]}"
do
    # Create the file with .txt extension and add "placeholder" text
    echo "placeholder" > "${file}.txt"
done
