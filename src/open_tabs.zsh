#!/bin/zsh

path="$1"
# Print the received path for debugging
echo "Received Path: $path"

# Convert the path to a format compatible with AppleScript using absolute paths
aspath=$(/usr/bin/sed 's/\//:/g' <<< "$path" | /usr/bin/sed 's/^://')

echo "Converted Path: $aspath"
# AppleScript to open in a new tab
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
