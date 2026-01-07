#!/bin/zsh

# Define log file
LOG_FILE="/Users/tomlord/dotfiles/launchd/launchd.log"

# Ensure log file directory exists
LOG_DIR=$(dirname "$LOG_FILE")
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR" || {
    echo "Error: Cannot create log directory $LOG_DIR"
    exit 1
  }
fi

# Function to trim log file to keep only the latest 10 entries
trim_log_file() {
  if [ -f "$LOG_FILE" ]; then
    # Keep only the last 10 lines and write to a temporary file
    tail -n 10 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
}

# Function to log messages with consistent date format
log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
  # Trim log file after each write to maintain only 10 entries
  trim_log_file
}

# Define target directory
TARGET_DIR="/Users/tomlord/superwhisper/recordings"

# Check if directory exists first
if [ ! -d "$TARGET_DIR" ]; then
    log_message "SuperWhisper recordings directory does not exist: $TARGET_DIR"
    exit 0
fi

# Try to delete contents while keeping the directory
if [ -w "$TARGET_DIR" ] || [ -w "$(dirname "$TARGET_DIR")" ]; then
    # We have write permission, try to delete contents
    if find "$TARGET_DIR" -mindepth 1 -delete 2>/dev/null; then
        log_message "SuperWhisper recordings directory contents deleted successfully"
    else
        log_message "Failed to delete SuperWhisper recordings directory contents - Permission denied. Please check macOS privacy settings."
    fi
else
    log_message "No write permission for SuperWhisper recordings directory. Please check macOS privacy settings."
fi