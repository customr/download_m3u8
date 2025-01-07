#!/bin/bash

input_dir="ts_files/1"

# Check each .ts file for the HTTP error message
for file in "$input_dir"/*.ts; do
    if grep -q "An error occurred while processing your request" "$file"; then
        echo "Corrupted file: $file"
        # Optionally, move the corrupted file to a separate directory
        mkdir -p "$input_dir/corrupted"
        mv "$file" "$input_dir/corrupted/"
    fi
done
