#!/bin/zsh

# Function to execute AppleScript to open a path in a new Finder tab
execute_applescript() {
    local target_path="$1"
    result=$(/usr/bin/osascript <<EOF
        tell application "Finder"
            activate
            tell application "System Events" to keystroke "t" using {command down}
            set target of front window to POSIX file "$target_path"
            return "Success"
        end tell
EOF
    )
    echo "AppleScript executed: $result"
}

# Function to process the path and then call the AppleScript executor
open_tab() {
    local path="$1"

    # Convert file to its containing directory if necessary
    [[ -f "$path" ]] && path=$(/usr/bin/dirname "$path")

    # Verify directory and open
    if [[ -d "$path" ]]; then
        echo "Opening: $path"
        execute_applescript "$path"
    else
        echo "Invalid directory: $path"
    fi
}

# Main function using path_input variable from Alfred
main() {
    # Use the path_input variable from Alfred
    if [[ -n "$path_input" ]]; then
        echo "Processing path from Alfred"
        open_tab "$path_input"
    else
        echo "No path provided"
    fi
}

# Execution
main
