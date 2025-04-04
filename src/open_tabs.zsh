#!/bin/zsh

# Function to open path in new tab
open_in_tab() {
    local path="$1"

    # If no path provided, exit
    [[ -z "$path" ]] && { echo "Error: No path provided"; return 1; }

    # If path is a file, get its directory
    [[ -f "$path" ]] && path="$(/usr/bin/dirname "$path")"

    # Verify it's a valid directory
    [[ ! -d "$path" ]] && { echo "Invalid directory: $path"; return 1; }

    echo "Opening: $path"

    # Use POSIX path directly instead of converting
    /usr/bin/osascript <<EOF
tell application "Finder"
    activate
    tell application "System Events" to keystroke "t" using {command down}
    set target of front window to POSIX file "$path"
end tell
EOF
}

# Main script
if [[ "$1" =~ ^\(.*\)$ ]]; then
    # Process array of paths
    eval "paths=$1"
    for path in "${paths[@]}"; do
        open_in_tab "$path"
    done
else
    # Process single path
    open_in_tab "$1"
fi
