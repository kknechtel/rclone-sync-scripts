#!/bin/bash

echo "Transfer Google Shared Drives to Box"
echo "==================================="
echo ""
echo "Available Shared Drives:"
echo "1. All Shared Drive"
echo "2. Finance-Client Reports"
echo "3. Finance-Marketing"
echo "4. Finance"
echo "5. HR-Google Drive"
echo ""

# Function to list contents of a shared drive
list_shared_drive() {
    local drive_id=$1
    local drive_name=$2
    echo ""
    echo "Listing contents of $drive_name:"
    ~/.local/bin/rclone lsd "NoginGoogleDrive:" --drive-team-drive "$drive_id" --max-depth 1
}

# Function to copy from shared drive to Box
copy_to_box() {
    local drive_id=$1
    local drive_name=$2
    local source_path=$3
    local dest_path=$4
    
    echo ""
    echo "Copying from $drive_name to Box..."
    echo "Source: $source_path"
    echo "Destination: Box:$dest_path"
    
    ~/.local/bin/rclone copy "NoginGoogleDrive:$source_path" "Box:$dest_path" \
        --drive-team-drive "$drive_id" \
        --progress \
        --stats 1s
}

# Example commands:
echo ""
echo "Example commands you can use:"
echo ""
echo "# List Finance shared drive contents:"
echo '~/.local/bin/rclone lsd "NoginGoogleDrive:" --drive-team-drive "0AJtNzO5k5RrQUk9PVA"'
echo ""
echo "# Copy entire Finance drive to Box:"
echo '~/.local/bin/rclone copy "NoginGoogleDrive:" "Box:Finance-Backup" --drive-team-drive "0AJtNzO5k5RrQUk9PVA" --progress'
echo ""
echo "# Copy specific folder from Finance to Box:"
echo '~/.local/bin/rclone copy "NoginGoogleDrive:FolderName" "Box:Finance/FolderName" --drive-team-drive "0AJtNzO5k5RrQUk9PVA" --progress'
echo ""
echo "# Sync HR drive to Box (be careful - this will delete files in Box that don't exist in source):"
echo '~/.local/bin/rclone sync "NoginGoogleDrive:" "Box:HR-Backup" --drive-team-drive "0AG-Zp33yeFLhUk9PVA" --dry-run'
echo ""

# Test listing Finance shared drive
echo "Testing: Listing Finance shared drive contents..."
~/.local/bin/rclone lsd "NoginGoogleDrive:" --drive-team-drive "0AJtNzO5k5RrQUk9PVA" --max-depth 1