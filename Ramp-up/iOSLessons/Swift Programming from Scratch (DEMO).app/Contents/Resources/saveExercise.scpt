tell application "Xcode"
activate
delay 0.4

tell application "System Events" to tell process "Xcode" to key code 1 using {command down, option down}

end tell
