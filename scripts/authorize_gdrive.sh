#!/bin/bash

echo "Authorizing Google Drive connection..."
echo ""
echo "This will open a URL for you to authorize rclone to access your Google Drive."
echo ""

# Try headless authorization first
echo "n" | ~/.local/bin/rclone config reconnect NoginGoogleDrive:

echo ""
echo "If you see an authorization URL above, please:"
echo "1. Copy the URL and paste it into your web browser"
echo "2. Log in to your Google account and authorize the app"
echo "3. Copy the authorization code that appears"
echo "4. Run this command and paste the code when prompted:"
echo "   ~/.local/bin/rclone config"
echo "   Then choose 'e' to edit NoginGoogleDrive and follow the prompts"