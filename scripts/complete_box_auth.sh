#!/bin/bash

echo "Completing Box Authorization"
echo "==========================="
echo ""
echo "You need to get a token from Box. Here's how:"
echo ""
echo "1. On your Windows machine, run:"
echo "   cd C:\\Rclone"
echo "   rclone.exe authorize \"box\""
echo ""
echo "2. This will open your browser and ask you to log into Box"
echo ""
echo "3. After authorizing, it will show you a token like:"
echo "   {\"access_token\":\"xxxxx\",\"token_type\":\"Bearer\",\"refresh_token\":\"xxxxx\",\"expiry\":\"2025-xx-xx\"}"
echo ""
echo "4. Copy the ENTIRE token (including the curly braces)"
echo ""
read -p "Paste the token here and press Enter: " TOKEN

# Update Box configuration with the token
~/.local/bin/rclone config update Box token "$TOKEN"

echo ""
echo "Testing Box connection..."
~/.local/bin/rclone lsd Box: --max-depth 1

echo ""
echo "If you see your Box folders above, the setup is complete!"