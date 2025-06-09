#!/bin/zsh

# Set PATH explicitly for crontab environment
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"

# Define the target directory for Heptabase backups
BACKUP_DIR="/Users/tomlord/Documents/HeptaWorkspace"

# Define log file
LOG_FILE="/Users/tomlord/dotfiles/launchd/launchd.log"

# Ensure log file directory exists
LOG_DIR=$(dirname "$LOG_FILE")
if [ ! -d "$LOG_DIR" ]; then
  /bin/mkdir -p "$LOG_DIR" || {
    echo "Error: Cannot create log directory $LOG_DIR"
    exit 1
  }
fi

# Function to trim log file to keep only the latest 10 entries
trim_log_file() {
  if [ -f "$LOG_FILE" ]; then
    # Keep only the last 10 lines and write to a temporary file
    /usr/bin/tail -n 10 "$LOG_FILE" > "${LOG_FILE}.tmp" && /bin/mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi
}

# Function to log messages - simplified to only log deletions with date
log_message() {
  local message="$1"
  echo "$(/bin/date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
  # Trim log file after each write to maintain only 10 entries
  trim_log_file
}

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  log_message "Error: Backup directory $BACKUP_DIR does not exist"
  exit 1
fi

# Check if we have read permission for the backup directory
if [ ! -r "$BACKUP_DIR" ]; then
  log_message "Error: No read permission for backup directory $BACKUP_DIR. Please check macOS privacy settings."
  exit 1
fi

# Find all Heptabase backup files and sort by modification time (newest first)
# Using ls -t to sort by modification time, then filtering for backup files
backup_files=$(/bin/ls -t "$BACKUP_DIR"/Heptabase-Data-Backup-*.zip 2>/dev/null)

# Check if we found any backup files
if [ -z "$backup_files" ]; then
  log_message "No Heptabase backup files found in $BACKUP_DIR"
  exit 0
fi

# Count total backup files (handle empty results properly)
total_files=$(echo "$backup_files" | /usr/bin/grep -c "Heptabase-Data-Backup-.*\.zip" 2>/dev/null || echo "0")

# Keep only the 2 newest files, delete the rest
if [ "$total_files" -gt 2 ]; then
  files_to_delete=$(echo "$backup_files" | /usr/bin/tail -n +3)
  
  deleted_count=0
  failed_count=0
  
  while IFS= read -r file; do
    if [ -n "$file" ] && [ -f "$file" ]; then
      # Check if we have write permission for the file
      if [ -w "$file" ] || [ -w "$(dirname "$file")" ]; then
        if /bin/rm "$file" 2>/dev/null; then
          log_message "Deleted old Heptabase backup: $(basename "$file")"
          ((deleted_count++))
        else
          log_message "Failed to delete: $(basename "$file") - Permission denied"
          ((failed_count++))
        fi
      else
        log_message "No write permission for: $(basename "$file") - Please check macOS privacy settings"
        ((failed_count++))
      fi
    fi
  done <<< "$files_to_delete"
  
  if [ $failed_count -gt 0 ]; then
    log_message "Heptabase backup cleanup completed with errors: $deleted_count deleted, $failed_count failed"
  else
    log_message "Heptabase backup cleanup completed successfully: $deleted_count old backups deleted"
  fi
else
  log_message "Found $total_files Heptabase backup files, no deletion needed (keeping ≤2 files)"
fi

