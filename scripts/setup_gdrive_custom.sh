#!/bin/bash

echo "Google Drive Configuration with Custom OAuth Client"
echo "=================================================="
echo ""
echo "You'll need the client_id and client_secret from your JSON file."
echo "Open your OAuth credentials JSON file."
echo ""
echo "Look for lines like:"
echo "  \"client_id\": \"xxxxxxxxx.apps.googleusercontent.com\""
echo "  \"client_secret\": \"GOCSPX-xxxxxxxxxxxxx\""
echo ""

# Get credentials from user
read -p "Enter your Client Secret from the JSON file: " CLIENT_SECRET

# Get Client ID from user
read -p "Enter your Client ID from the JSON file: " CLIENT_ID

echo ""
echo "Using Client ID: $CLIENT_ID"
echo "Using Client Secret: [hidden]"
echo ""

# Delete existing remote
echo "Removing existing configuration..."
~/.local/bin/rclone config delete NoginGoogleDrive 2>/dev/null

# Create configuration commands
echo "Creating new Google Drive remote..."

# Use expect or manual config since auto config might have issues
cat > /tmp/rclone_manual_config.txt << EOF
n
NoginGoogleDrive
drive
$CLIENT_ID
$CLIENT_SECRET
1
n
n
EOF

~/.local/bin/rclone config < /tmp/rclone_manual_config.txt

rm /tmp/rclone_manual_config.txt

echo ""
echo "Now we need to authorize rclone to access your Google Drive."
echo "Run this command to complete authorization:"
echo ""
echo "~/.local/bin/rclone config reconnect NoginGoogleDrive:"
echo ""
echo "It will give you a URL to visit. Copy and paste it into your browser,"
echo "authorize the app, and then copy the authorization code back."