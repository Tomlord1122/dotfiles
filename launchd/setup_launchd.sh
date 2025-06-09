#!/bin/zsh

# macOS launchd task management script
# Used to replace cron tasks with launchd settings

# Define color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define paths
DOTFILES_DIR="/Users/tomlord/dotfiles"
LAUNCHAGENTS_DIR="$HOME/Library/LaunchAgents"

# plist file list
PLIST_FILES=(
    "com.tomlord.delete-record.plist"
    "com.tomlord.delete-hepta-backup.plist"
)

# Function: Print a message with color
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function: Check if plist files exist
check_plist_files() {
    local missing_files=()
    
    for plist in "${PLIST_FILES[@]}"; do
        if [[ ! -f "$DOTFILES_DIR/$plist" ]]; then
            missing_files+=("$plist")
        fi
    done
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_message $RED "Error: The following plist files do not exist:"
        for file in "${missing_files[@]}"; do
            echo "  - $DOTFILES_DIR/$file"
        done
        return 1
    fi
    
    return 0
}

# Function: Install launchd tasks
install_tasks() {
    print_message $BLUE "Starting to install launchd tasks..."
    
    # Check plist files
    if ! check_plist_files; then
        return 1
    fi
    
    # Ensure LaunchAgents directory exists
    if [[ ! -d "$LAUNCHAGENTS_DIR" ]]; then
        mkdir -p "$LAUNCHAGENTS_DIR"
        print_message $GREEN "Created directory: $LAUNCHAGENTS_DIR"
    fi
    
    # Copy and load each plist file
    for plist in "${PLIST_FILES[@]}"; do
        local source_file="$DOTFILES_DIR/$plist"
        local target_file="$LAUNCHAGENTS_DIR/$plist"
        
        # Copy file
        cp "$source_file" "$target_file"
        print_message $GREEN "Copied: $plist"
        
        # Load task
        if launchctl load "$target_file"; then
            print_message $GREEN "Loaded: $plist"
        else
            print_message $RED "Load failed: $plist"
        fi
    done
    
    print_message $BLUE "Installation complete!"
}

# Function: Uninstall launchd tasks
uninstall_tasks() {
    print_message $BLUE "Starting to uninstall launchd tasks..."
    
    for plist in "${PLIST_FILES[@]}"; do
        local target_file="$LAUNCHAGENTS_DIR/$plist"
        local label=$(basename "$plist" .plist)
        
        # Unload task
        if launchctl unload "$target_file" 2>/dev/null; then
            print_message $GREEN "Unloaded: $plist"
        else
            print_message $YELLOW "Task not loaded or already unloaded: $plist"
        fi
        
        # Delete file
        if [[ -f "$target_file" ]]; then
            rm "$target_file"
            print_message $GREEN "Deleted: $plist"
        fi
    done
    
    print_message $BLUE "Uninstallation complete!"
}

# Function: Check task status
check_status() {
    print_message $BLUE "Checking launchd task status..."
    
    for plist in "${PLIST_FILES[@]}"; do
        local label=$(basename "$plist" .plist)
        local target_file="$LAUNCHAGENTS_DIR/$plist"
        
        echo ""
        print_message $YELLOW "Task: $label"
        
        if [[ -f "$target_file" ]]; then
            echo "  File exists: ✓"
            
            # Check if loaded
            if launchctl list | grep -q "$label"; then
                echo "  Load status: ✓ Loaded"
                
                # Display task information
                echo "  Task details:"
                launchctl list "$label" 2>/dev/null | head -10
            else
                echo "  Load status: ✗ Not loaded"
            fi
        else
            echo "  File exists: ✗"
        fi
    done
}

# Function: Reload tasks
reload_tasks() {
    print_message $BLUE "Reloading launchd tasks..."
    uninstall_tasks
    sleep 2
    install_tasks
}

# Function: Show help information
show_help() {
    echo "macOS launchd task management script"
    echo ""
    echo "Usage:"
    echo "  $0 install    - Install all launchd tasks"
    echo "  $0 uninstall  - Uninstall all launchd tasks"
    echo "  $0 status     - Check task status"
    echo "  $0 reload     - Reload tasks"
    echo "  $0 help       - Show this help information"
    echo ""
    echo "Task list:"
    for plist in "${PLIST_FILES[@]}"; do
        echo "  - $(basename "$plist" .plist)"
    done
}

# Main program
case "$1" in
    install)
        install_tasks
        ;;
    uninstall)
        uninstall_tasks
        ;;
    status)
        check_status
        ;;
    reload)
        reload_tasks
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_message $RED "Error: Unknown command '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac 