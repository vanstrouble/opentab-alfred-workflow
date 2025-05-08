#!/bin/zsh

# Function to execute AppleScript to open a path in a new Finder tab
execute_applescript() {
    local target_path="$1"
    /usr/bin/osascript <<EOF
tell application "Finder"
    activate
    tell application "System Events" to keystroke "t" using {command down}
    set target of front window to POSIX file "$target_path"
end tell
EOF
}

# Function to process the path and then call the AppleScript executor
open_tab() {
    local path="$1"

    # Convert file to its containing directory if necessary
    [[ -f "$path" ]] && path=$(/usr/bin/dirname "$path")

    # Verify directory and open
    if [[ -d "$path" ]]; then
        echo -n "Opening: $path"
        execute_applescript "$path"
    else
        echo -n "Invalid directory: $path"
    fi
}

# Optimized main function
main() {
    echo -n "Processing ${#} paths"
    for path in "$@"; do
        open_tab "$path"
    done
}

# Execution
main "$@"
