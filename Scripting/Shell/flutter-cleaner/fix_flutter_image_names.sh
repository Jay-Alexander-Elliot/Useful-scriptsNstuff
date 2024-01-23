#!/bin/bash

# Function to rename files according to Flutter's naming standards.
rename_file() {
    local file=$1  # The full path of the file to be renamed.
    local dir=$(dirname "$file")  # Extracts the directory path of the file.
    local base=$(basename "$file")  # Extracts the filename itself.
    
    # Converts filename to lowercase, replaces spaces with underscores,
    # and removes special characters not allowed in resource names.
    local newname=$(echo "$base" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9._-]//g')

    # Check if the new name is different from the original name.
    if [[ "$base" != "$newname" ]]; then
        # In dry run mode, just display what would happen.
        if [[ $DRY_RUN -eq 0 ]]; then
            echo "Renaming: $dir/$base -> $dir/$newname"
            # If backup mode is enabled, copy the original file to a backup.
            if [[ $BACKUP -eq 1 ]]; then
                cp "$dir/$base" "$dir/$base.bak"
            fi
            # Perform the actual file rename.
            mv "$dir/$base" "$dir/$newname"
        else
            # Display the proposed change without executing it.
            echo "Would rename: $dir/$base -> $dir/$newname"
        fi
    fi
}

# Initial settings: By default, both dry run and backup are off, and recursive is on.
DRY_RUN=0
BACKUP=0
RECURSIVE=1

# Processing command-line options passed to the script.
# -d for dry run, -r to disable recursion, and -b for backup.
while getopts "drb" opt; do
  case $opt in
    d) DRY_RUN=1 ;;
    r) RECURSIVE=0 ;;
    b) BACKUP=1 ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Inform the user if the script is running in dry run mode.
if [[ $DRY_RUN -eq 1 ]]; then
    echo "Running in dry-run mode. No files will be changed."
fi

# Inform the user if backup mode is enabled.
if [[ $BACKUP -eq 1 ]]; then
    echo "Backup mode enabled. Original files will be backed up."
fi

# Export the function and variables so they are available within the 'find' command.
export -f rename_file
export DRY_RUN
export BACKUP

# Construct the find command based on whether recursive search is enabled.
if [[ $RECURSIVE -eq 0 ]]; then
    FIND_CMD="find . -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' -o -name '*.bmp' -o -name '*.webp' \) -exec bash -c 'rename_file \"$0\"' {} \;"
else
    FIND_CMD="find . -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' -o -name '*.bmp' -o -name '*.webp' \) -exec bash -c 'rename_file \"$0\"' {} \;"
fi

# Execute the constructed find command.
eval $FIND_CMD

# Notify the user that the operation is complete.
echo "Operation completed."
