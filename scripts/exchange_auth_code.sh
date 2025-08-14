#!/bin/bash

echo "Google Drive Manual Authorization Token Exchange"
echo "==============================================="
echo ""
echo "Please follow the instructions in manual_auth_instructions.txt first!"
echo ""
read -p "Enter the authorization code from the URL: " AUTH_CODE

# You need to set these variables with your OAuth credentials
# CLIENT_ID="your-client-id-here"
# CLIENT_SECRET="your-client-secret-here"

# Get credentials from environment or prompt user
if [ -z "$CLIENT_ID" ]; then
    read -p "Enter your Google OAuth Client ID: " CLIENT_ID
fi
if [ -z "$CLIENT_SECRET" ]; then
    read -p "Enter your Google OAuth Client Secret: " CLIENT_SECRET
fi

# Exchange the code for a token
echo "Exchanging authorization code for token..."

RESPONSE=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d "code=$AUTH_CODE" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "redirect_uri=http://127.0.0.1:53682/" \
  -d "grant_type=authorization_code")

echo ""
echo "Response from Google:"
echo "$RESPONSE"
echo ""

# Extract the refresh token
REFRESH_TOKEN=$(echo "$RESPONSE" | grep -o '"refresh_token":"[^"]*' | cut -d'"' -f4)

if [ -n "$REFRESH_TOKEN" ]; then
    echo "Success! Refresh token obtained."
    echo ""
    echo "Now updating rclone configuration..."
    
    # Update the rclone config with the token
    ~/.local/bin/rclone config update NoginGoogleDrive token "{\"access_token\":\"\",\"token_type\":\"Bearer\",\"refresh_token\":\"$REFRESH_TOKEN\",\"expiry\":\"2025-01-01T00:00:00.000000000Z\"}"
    
    echo ""
    echo "Testing the connection..."
    ~/.local/bin/rclone lsd NoginGoogleDrive: --max-depth 1
else
    echo "Error: Could not extract refresh token. Please check the authorization code."
fi