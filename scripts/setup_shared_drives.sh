#!/bin/bash

echo "Google Shared Drives Configuration"
echo "================================="
echo ""
echo "You have access to these shared drives:"
echo ""
echo "1. All Shared Drive (ID: 0APAvXXBmaTOoUk9PVA)"
echo "2. Finance-Client Reports (ID: 0AHa_9Sm-nJH2Uk9PVA)"
echo "3. Finance-Marketing (ID: 0AKqVlwq9o02yUk9PVA)"
echo "4. Finance (ID: 0AJtNzO5k5RrQUk9PVA)"
echo "5. HR-Google Drive (ID: 0AG-Zp33yeFLhUk9PVA)"
echo ""

echo "This script requires you to have already configured your Google Drive credentials."
echo "The credentials should be stored in your rclone config."
echo ""

# Get credentials from existing config
if [ ! -f ~/.config/rclone/rclone.conf ]; then
    echo "Error: rclone config not found. Please run setup_gdrive.sh first."
    exit 1
fi

# Check if NoginGoogleDrive exists
if ! ~/.local/bin/rclone config show NoginGoogleDrive > /dev/null 2>&1; then
    echo "Error: NoginGoogleDrive remote not found. Please run setup_gdrive.sh first."
    exit 1
fi

echo "Creating convenient remotes for each shared drive..."
echo ""
echo "Note: This will copy authentication from your existing NoginGoogleDrive remote."
echo ""

# Function to create shared drive remote
create_shared_drive() {
    local name=$1
    local drive_id=$2
    local display_name=$3
    
    echo "Creating $display_name..."
    ~/.local/bin/rclone config copy NoginGoogleDrive "$name"
    ~/.local/bin/rclone config update "$name" team_drive "$drive_id"
}

# Create remotes for each shared drive
create_shared_drive "GDrive-AllShared" "0APAvXXBmaTOoUk9PVA" "All Shared Drive"
create_shared_drive "GDrive-FinanceReports" "0AHa_9Sm-nJH2Uk9PVA" "Finance-Client Reports"
create_shared_drive "GDrive-FinanceMarketing" "0AKqVlwq9o02yUk9PVA" "Finance-Marketing"
create_shared_drive "GDrive-Finance" "0AJtNzO5k5RrQUk9PVA" "Finance"
create_shared_drive "GDrive-HR" "0AG-Zp33yeFLhUk9PVA" "HR-Google Drive"

echo ""
echo "Done! Created these remotes:"
echo "- GDrive-AllShared"
echo "- GDrive-FinanceReports"
echo "- GDrive-FinanceMarketing"
echo "- GDrive-Finance"
echo "- GDrive-HR"
echo ""
echo "Testing access to Finance shared drive..."
~/.local/bin/rclone lsd GDrive-Finance: --max-depth 1 2>/dev/null || echo "Note: You may need to reconnect if the token has expired."