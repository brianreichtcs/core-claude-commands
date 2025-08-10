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

SOURCE_AGENTS_DIR="./.claude/agents"
TARGET_AGENTS_DIR="$HOME/.claude/agents"

if [ ! -d "$SOURCE_AGENTS_DIR" ]; then
    echo "Error: Source directory $SOURCE_AGENTS_DIR does not exist"
    exit 1
fi

# Copy agents to user's Claude directory
echo "Copying Claude agents to $TARGET_AGENTS_DIR..."
cp -r "$SOURCE_AGENTS_DIR"/* "$TARGET_AGENTS_DIR/"

echo "Successfully installed Claude agents to $TARGET_AGENTS_DIR"
echo "Agents available:"
ls -1 "$TARGET_AGENTS_DIR"

