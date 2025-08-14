#!/bin/bash

echo "Setting up Box.com with rclone"
echo "=============================="
echo ""
echo "This will guide you through connecting Box to rclone."
echo ""
echo "You have two options:"
echo "1. Use rclone's default Box app (easiest)"
echo "2. Create your own Box app (more control)"
echo ""
read -p "Choose option (1 or 2): " OPTION

if [ "$OPTION" = "1" ]; then
    echo ""
    echo "Using rclone's default Box app..."
    echo ""
    
    # Create Box remote with default app
    cat << EOF > /tmp/box_config.txt
n
Box
box


y
EOF
    
    ~/.local/bin/rclone config < /tmp/box_config.txt
    rm /tmp/box_config.txt
    
elif [ "$OPTION" = "2" ]; then
    echo ""
    echo "To create your own Box app:"
    echo "1. Go to https://app.box.com/developers/console"
    echo "2. Click 'Create New App'"
    echo "3. Choose 'Custom App'"
    echo "4. Choose 'OAuth 2.0'"
    echo "5. Name it (e.g., 'rclone')"
    echo "6. Set redirect URI to: http://localhost:53682/"
    echo "7. Save and copy the Client ID and Client Secret"
    echo ""
    
    read -p "Enter Box Client ID: " CLIENT_ID
    read -p "Enter Box Client Secret: " CLIENT_SECRET
    
    echo ""
    echo "Creating Box remote with custom app..."
    
    cat << EOF > /tmp/box_config.txt
n
Box
box
$CLIENT_ID
$CLIENT_SECRET
y
EOF
    
    ~/.local/bin/rclone config < /tmp/box_config.txt
    rm /tmp/box_config.txt
fi

echo ""
echo "Testing Box connection..."
~/.local/bin/rclone lsd Box: --max-depth 1