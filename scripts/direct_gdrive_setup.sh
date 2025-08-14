#!/bin/bash

# Replace this with your actual client secret
CLIENT_SECRET="YOUR_CLIENT_SECRET_HERE"
CLIENT_ID="738415475416-80b73usm0bf7mbk0r5j7hckucsmi9mst.apps.googleusercontent.com"

# Delete old config
~/.local/bin/rclone config delete NoginGoogleDrive 2>/dev/null

# Create new remote
~/.local/bin/rclone config create NoginGoogleDrive drive \
  client_id="$CLIENT_ID" \
  client_secret="$CLIENT_SECRET" \
  scope="drive" \
  token="" \
  config_is_local="false" \
  config_refresh_token="true"

echo "Configuration created. Now authorize it:"
echo "~/.local/bin/rclone config reconnect NoginGoogleDrive:"