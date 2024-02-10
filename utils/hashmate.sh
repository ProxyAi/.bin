#!/bin/bash

#!/bin/bash

script_dir=$(dirname "$0")
folder_path="$script_dir"  # Use the script's folder path as the folder to process

# Iterate over each file in the folder
for file_path in "$folder_path"/*; do
    if [ -f "$file_path" ]; then
        # Calculate the MD5 hash
        md5_hash=$(md5sum "$file_path" | awk '{ print $1 }')
        echo "File: $file_path  MD5: $md5_hash"
    fi
done
