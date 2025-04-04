import os
import subprocess


def open_finder_tab(path):
    path = os.path.abspath(path)
    aspath = path.replace("/", ":")[1:]
    script = f"""
tell application "Finder"
    activate
end tell

tell application "System Events" to keystroke "t" using {{command down}}

tell application "Finder"
    set startupDisk to path to startup disk as text
    set docs_path to startupDisk & "{aspath}" as text
    set target of front window to docs_path
end tell
"""
    subprocess.run(["osascript", "-e", script])


# Call function to open from Alfred
open_finder_tab("{query}")
