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
    echo -n "AppleScript executed: $result"
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
        echo -n "Invalid directory: $path"
    fi
}

# Main function using path_input variable from Alfred
main() {
    # Use the path_input variable from Alfred
    if [[ -n "$path_input" ]]; then
        echo "Processing paths from Alfred"

        # Split by tabs and process each path
        IFS=$'\t' read -r -A paths <<< "$path_input"
        for path in "${paths[@]}"; do
            open_tab "$path"
        done
    else
        echo -n "No path provided"
    fi
}

# Execution
main
