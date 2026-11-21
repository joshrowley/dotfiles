#!/bin/bash

# Claude Code session export script
# This script is called by the Claude Code "Stop" hook

# Read JSON input from stdin and extract transcript_path
INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

# Exit if no transcript path provided or if jq failed
if [ -z "$TRANSCRIPT_PATH" ] || [ "$TRANSCRIPT_PATH" = "null" ]; then
    echo "No transcript path provided in input: $INPUT"
    exit 1
fi

# Exit if transcript file doesn't exist
if [ ! -f "$TRANSCRIPT_PATH" ]; then
    echo "Transcript file not found: $TRANSCRIPT_PATH"
    exit 1
fi

# Create export directory if it doesn't exist
EXPORT_DIR="$HOME/claude-sessions"
mkdir -p "$EXPORT_DIR"

# Generate filename with timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="claude-session_${TIMESTAMP}.md"
EXPORT_PATH="$EXPORT_DIR/$FILENAME"

# Copy the transcript
cp "$TRANSCRIPT_PATH" "$EXPORT_PATH"

# Log the export
echo "Session exported to: $EXPORT_PATH" >> "$EXPORT_DIR/export.log"

echo "Session exported successfully to $EXPORT_PATH"