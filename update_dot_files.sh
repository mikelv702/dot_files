#!/usr/bin/env bash

# Get the directory of the current script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set the destination directory (home directory)
dest_dir="$HOME"

# Function to copy dot files
copy_dot_files() {
    echo "Copying dot files..."
    for file in "$script_dir"/.*; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "." ] && [ "$(basename "$file")" != ".." ]; then
            cp -v "$file" "$dest_dir"
        fi
    done
}

# Function to copy specific directories
copy_directories() {
    echo "Copying directories..."
    # Add directories to this array as needed
    directories=(".vim")
    
    for dir in "${directories[@]}"; do
        if [ -d "$script_dir/$dir" ]; then
            cp -rv "$script_dir/$dir" "$dest_dir"
        else
            echo "Directory $dir not found in $script_dir"
        fi
    done
}

# Main execution
copy_dot_files
copy_directories
