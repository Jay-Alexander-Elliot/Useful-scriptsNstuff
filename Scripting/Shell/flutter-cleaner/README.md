## Usage Instructions for `flutter_image_rename.sh`

This script is designed to automatically rename image files in your Flutter project to meet Flutter's naming standards. It converts filenames to lowercase, replaces spaces with underscores, and removes special characters.

### Steps to Use the Script:

1. **Save the Script**:  
   Save the contents of the script into a file named `flutter_image_rename.sh` in the root of your Flutter project.

2. **Make the Script Executable**:  
   Before using the script, you need to make it executable. Run the following command in your terminal:
   ```bash
   chmod +x flutter_image_rename.sh
   ```
3. **Run the Script**:
   You can run the script in different modes depending on your need:

**Default Mode**: To run the script in its default mode (recursive, no backup, and actual execution), use:
```
./flutter_image_rename.sh
```
**Dry Run**: To see what changes the script would make without actually renaming any files, use:
```
./flutter_image_rename.sh -d
```
**Non-Recursive Mode**: To run the script only in the current directory (without going into subdirectories), use:
```
./flutter_image_rename.sh -r
```
**With Backup**: To create backups of the original files before renaming, use:
```
./flutter_image_rename.sh -b
```

**Note**
- The script will process files with extensions .png, .jpg, .jpeg, .gif, .bmp, and .webp.
- It is recommended to use the dry run option initially to review the proposed changes.
- Use the backup option to prevent accidental data loss.
