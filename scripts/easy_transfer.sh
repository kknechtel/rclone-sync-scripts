#!/bin/bash

echo "Easy Finance to Box Transfer Script"
echo "==================================="
echo ""
echo "Available Finance folders:"
echo ""
~/.local/bin/rclone lsd Finance-SharedDrive: --max-depth 1 | head -20
echo ""
echo "To transfer a folder, run:"
echo "~/.local/bin/rclone copy Finance-SharedDrive:FOLDER_NAME Box:Finance-Backup/FOLDER_NAME --progress"
echo ""
echo "For example, to transfer the Banking folder:"
echo "~/.local/bin/rclone copy Finance-SharedDrive:Banking Box:Finance-Backup/Banking --progress"
echo ""
read -p "Enter the folder name you want to transfer (or 'exit' to quit): " FOLDER

if [ "$FOLDER" != "exit" ]; then
    echo ""
    echo "Starting transfer of $FOLDER to Box..."
    ~/.local/bin/rclone copy "Finance-SharedDrive:$FOLDER" "Box:Finance-Backup/$FOLDER" --progress -v
fi