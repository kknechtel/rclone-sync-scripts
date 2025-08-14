#!/bin/bash

echo "Google Drive Configuration for rclone"
echo "===================================="
echo ""
echo "Please enter your Google OAuth credentials:"
echo ""

# Get client secret from user
read -p "Enter your Client Secret (from the JSON file): " CLIENT_SECRET

# Confirm the client ID
echo ""
echo "Using Client ID: 738415475416-d89qj340tk7s70pslg14p45tql5qradh.apps.googleusercontent.com"
echo ""

# Delete existing config
echo "Removing existing configuration..."
~/.local/bin/rclone config delete NoginGoogleDrive 2>/dev/null

# Configure using rclone config with the credentials
echo "Creating new Google Drive remote..."
~/.local/bin/rclone config create NoginGoogleDrive drive \
  client_id="738415475416-d89qj340tk7s70pslg14p45tql5qradh.apps.googleusercontent.com" \
  client_secret="$CLIENT_SECRET" \
  scope="drive" \
  config_is_local="false" \
  config_refresh_token="true"

echo ""
echo "Configuration complete! Testing connection..."
~/.local/bin/rclone lsd NoginGoogleDrive: --max-depth 1