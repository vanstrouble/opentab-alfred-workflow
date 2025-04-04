#!/bin/zsh

# Optimized function to open a path in a new Finder tab
open_tab() {
    local path="$1"

    # Convert file to its containing directory if necessary
    [[ -f "$path" ]] && path=$(/usr/bin/dirname "$path")

    # Verify directory and open
    if [[ -d "$path" ]]; then
        echo "Opening: $path"
        /usr/bin/osascript <<EOF
tell application "Finder"
    activate
    tell application "System Events" to keystroke "t" using {command down}
    set target of front window to POSIX file "$path"
end tell
EOF
    else
        echo "Invalid directory: $path"
    fi
}

# Optimized main function
main() {
    echo "Processing ${#} paths"
    for path in "$@"; do
        open_tab "$path"
    done
}

# Execution
main "$@"
