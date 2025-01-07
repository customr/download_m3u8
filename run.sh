#!/bin/bash

# Directory containing the .bin files
input_dir="ts_files/1"
output_file="output.mp4"

# Step 1: Rename .bin files to .ts
for file in "$input_dir"/*.bin; do
    mv "$file" "${file%.bin}.ts"
done

# Step 2: Create a text file with the list of .ts files
list_file="file_list.txt"
> "$list_file"  # Clear the file if it exists

for file in "$input_dir"/*.ts; do
    echo "file '$file'" >> "$list_file"
done

# Step 3: Use ffmpeg to concatenate the files
ffmpeg -f concat -safe 0 -i "$list_file" -c copy "$output_file"

# Clean up (optional)
# rm "$list_file"
# for file in "$input_dir"/*.ts; do
#     mv "$file" "${file%.ts}.bin"
# done

echo "Merging complete. Output file: $output_file"
