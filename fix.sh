#!/bin/bash

# Path to the .m3u8 file
m3u8_file="m3u8/1.m3u8"

# Directory where the .ts files are stored
output_dir="ts_files/1"

# Temporary file to store URLs from the .m3u8 file
url_list="url_list.txt"

# Step 1: Extract URLs from the .m3u8 file
grep -E "^https?://" "$m3u8_file" > "$url_list"

# Step 2: Check each file for corruption and re-download if necessary
while read -r url; do
    # Extract the filename from the URL (e.g., 4998.bin)
    bin_filename=$(basename "$url" | cut -d'?' -f1)  # Remove query parameters
    ts_filename="${bin_filename%.bin}.ts"  # Replace .bin with .ts
    filepath="$output_dir/$ts_filename"

    # Check if the .ts file exists and is corrupted
    if [ -f "$filepath" ] && grep -q "An error occurred while processing your request" "$filepath"; then
        echo "Re-downloading corrupted file: $bin_filename (saving as $ts_filename)"
        wget -O "$filepath" "$url"
    elif [ ! -f "$filepath" ]; then
        echo "Downloading missing file: $bin_filename (saving as $ts_filename)"
        wget -O "$filepath" "$url"
    else
        echo "File is valid: $ts_filename"
    fi
done < "$url_list"

# Clean up
rm "$url_list"

echo "Re-download complete."
