#!/bin/bash

echo "Setting up Google Drive with rclone (Easy Method)"
echo "================================================"
echo ""
echo "This will use rclone's built-in OAuth app (no need to create your own)"
echo ""

# Delete existing remote
echo "Removing existing configuration..."
~/.local/bin/rclone config delete NoginGoogleDrive 2>/dev/null

# Create new remote with default OAuth
cat << EOF > /tmp/rclone_config_input.txt
n
NoginGoogleDrive
drive
1
n
y
EOF

echo "Configuring Google Drive..."
~/.local/bin/rclone config < /tmp/rclone_config_input.txt

rm /tmp/rclone_config_input.txt

echo ""
echo "Configuration should be complete! The browser should have opened for authentication."
echo ""
echo "Testing connection..."
~/.local/bin/rclone lsd NoginGoogleDrive: --max-depth 1