#!/bin/bash

# Install script to copy Claude commands to user's home directory

set -e

SOURCE_DIR="./.claude/commands"
TARGET_DIR="$HOME/.claude/commands"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy commands to user's Claude directory
echo "Copying Claude commands to $TARGET_DIR..."
cp -r "$SOURCE_DIR"/* "$TARGET_DIR/"

echo "Successfully installed Claude commands to $TARGET_DIR"
echo "Commands available:"
ls -1 "$TARGET_DIR"
