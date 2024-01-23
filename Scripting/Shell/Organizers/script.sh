#!/bin/bash

# Ask the user for the number of output files
echo -n "Enter the number of output files: "
read num_output_files

# Check if the input is a valid number
if ! [[ "$num_output_files" =~ ^[0-9]+$ ]] || [ "$num_output_files" -le 0 ]; then
    echo "Invalid number of output files. Please enter a positive integer."
    exit 1
fi

# Initialize file counter and output file index
file_counter=0
output_index=1

# Create an array to hold the names of the output files
output_files=()
for i in $(seq 1 $num_output_files); do
    output_files+=("output$i.txt")
done

# Calculate the number of files to put in each output file
total_txt_files=$(ls -1 *.txt | wc -l)
((total_txt_files-=num_output_files))
files_per_output=$((total_txt_files / num_output_files))
[ $((total_txt_files % num_output_files)) -ne 0 ] && ((files_per_output++))

# Loop through all text files in the current directory
for file in *.txt; do
    # Skip if the file is one of the output files
    if [[ " ${output_files[*]} " =~ " ${file} " ]]; then
        continue
    fi

    # Append the contents of the file to the current output file
    cat "$file" >> "${output_files[$((output_index - 1))]}"

    # Increment file counter and check if it's time to switch to the next output file
    ((file_counter++))
    if ((file_counter == files_per_output)); then
        file_counter=0
        ((output_index++))
    fi
done

echo "Files combined into ${output_files[*]}"
