#!/bin/bash

# Number of folders and files to create
FOLDER_COUNT=3
FILES_PER_FOLDER=2

# Base directory
BASE_DIR="./random_data"

# Create base directory
mkdir -p "$BASE_DIR"

# Loop to create folders and files
for ((i = 1; i <= FOLDER_COUNT; i++)); do
    FOLDER_NAME="folder_$RANDOM"
    FULL_PATH="$BASE_DIR/$FOLDER_NAME"

    mkdir -p "$FULL_PATH"
    echo "Created folder: $FULL_PATH"

    for ((j = 1; j <= FILES_PER_FOLDER; j++)); do
        FILE_PATH="$FULL_PATH/file_$j.txt"
        echo "This is file #$j inside $FOLDER_NAME" > "$FILE_PATH"
        echo "Created file: $FILE_PATH"
    done
done

echo "All folders and files created successfully."

