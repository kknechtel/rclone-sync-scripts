#!/bin/bash

echo "Setting up Google Drive with rclone..."
echo ""
echo "Please have ready:"
echo "1. Your Client ID: 738415475416-mgqqf5v320bmebecll53t91md8tehtqk.apps.googleusercontent.com"
echo "2. Your Client Secret from Google Cloud Console"
echo ""
echo "IMPORTANT: Make sure you've added these redirect URIs in Google Cloud Console:"
echo "- http://localhost:53682/"
echo "- http://127.0.0.1:53682/"
echo ""
read -p "Press Enter when ready to continue..."

# Delete existing remote and recreate
~/.local/bin/rclone config delete NoginGoogleDrive

# Create new remote
~/.local/bin/rclone config create NoginGoogleDrive drive \
  client_id=738415475416-mgqqf5v320bmebecll53t91md8tehtqk.apps.googleusercontent.com \
  client_secret="$CLIENT_SECRET" \
  config_is_local=true \
  config_refresh_token=true