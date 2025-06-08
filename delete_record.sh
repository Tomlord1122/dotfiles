#!/bin/bash

# Attempt to remove the directory
if rm -rf /Users/tomlord/Documents/superwhisper/recordings/; then
    # Check if the directory still exists after attempting to remove it
    if [ -d "/Users/tomlord/Documents/superwhisper/recordings/" ]; then
        echo "Failed to delete the directory"
    else
        echo "Successfully deleted the directory"
    fi
else
    echo "Failed to delete the directory"
fi

