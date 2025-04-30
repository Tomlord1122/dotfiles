#!/bin/bash

# Define log file
LOG_FILE="/Users/tomlord/dotfiles/log.log"

# Ensure log file directory exists
LOG_DIR=$(dirname "$LOG_FILE")
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR" || {
    echo "Error: Cannot create log directory $LOG_DIR"
    exit 1
  }
fi

# Function to log messages to file and console
log_message() {
  local message="$1"
  echo "$message"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" > "$LOG_FILE"
}

# Find TCIM process (exact match, case-sensitive)
pids=$(ps -aA | grep '[T]CIM' | awk '{print $1}')

if [ -z "$pids" ]; then
  log_message "Process named TCIM not found"
else
  while read -r pid; do
    if kill -9 "$pid" 2>/dev/null; then
      log_message "Successfully killed TCIM process with PID $pid"
    else
      log_message "Failed to kill TCIM process with PID $pid"
    fi
  done <<< "$pids"
  sleep 1  # Wait briefly to allow process to exit
  log_message "Completed"
fi

