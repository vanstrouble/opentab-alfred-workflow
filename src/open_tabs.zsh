#!/bin/zsh

# Function to convert path to AppleScript format
convert_path() {
    echo "$1" | /usr/bin/sed 's/\//:/g' | /usr/bin/sed 's/^://'
}

# Function to open path in new tab
open_in_tab() {
    local path="$1"

    # If no path provided, exit
    if [[ -z "$path" ]]; then
        echo "Error: No path provided"
        return 1
    fi

    # If path is a file, get its directory
    if [[ -f "$path" ]]; then
        path="$(/usr/bin/dirname "$path")"
    fi

    # Verify it's a valid directory
    if [[ ! -d "$path" ]]; then
        echo "Invalid directory: $path"
        return 1
    fi

    local aspath=$(convert_path "$path")
    echo "Opening: $path"
    echo "Converted path: $aspath"

    /usr/bin/osascript <<EOF
tell application "Finder"
    activate
end tell

tell application "System Events" to keystroke "t" using {command down}

tell application "Finder"
    set startupDisk to path to startup disk as text
    set docs_path to startupDisk & "$aspath" as text
    set target of front window to docs_path
end tell
EOF
}

# Handle input - could be a single path or an array of paths
input="$1"

# Check if input is a single path (does not start with '(' and end with ')')
if [[ ! "$input" =~ ^\(.*\)$ ]]; then
    # Single path
    open_in_tab "$input"
else
    # Convert the string representation of array to actual array
    eval "paths=$input"
    # Process each path
    for path in "${paths[@]}"; do
        open_in_tab "$path"
    done
fi
