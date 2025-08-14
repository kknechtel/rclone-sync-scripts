# Rclone Google Drive to Box Sync

This repository contains scripts and documentation for setting up rclone to sync files between Google Drive (including Shared Drives) and Box.

## Overview

This project helps you:
- Connect to Google Drive and access Shared Drives
- Connect to Box.com cloud storage
- Transfer files between Google Drive and Box
- Access files through the rclone WebUI

## Prerequisites

- Linux/WSL environment
- rclone installed (scripts included for installation)
- Google account with access to shared drives
- Box.com account

## Quick Start

### 1. Install rclone (if not already installed)
```bash
cd ~
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
mkdir -p ~/.local/bin
cp rclone ~/.local/bin/
```

### 2. Configure Google Drive
```bash
# Run the Google Drive setup script
./scripts/setup_gdrive.sh
```

### 3. Configure Box
```bash
# Run the Box setup script
./scripts/setup_box.sh
```

### 4. Transfer Files
```bash
# Use the easy transfer script
./scripts/easy_transfer.sh

# Or transfer manually
rclone copy Finance-SharedDrive:FolderName Box:Finance-Backup/FolderName --progress
```

## Available Scripts

### Setup Scripts
- `setup_gdrive.sh` - Configure Google Drive with custom OAuth
- `setup_gdrive_easy.sh` - Configure Google Drive with rclone's default OAuth
- `setup_box.sh` - Configure Box.com connection
- `setup_gdrive_custom.sh` - Configure Google Drive with your own OAuth credentials

### Transfer Scripts
- `easy_transfer.sh` - Interactive script to transfer folders
- `transfer_to_box.sh` - Comprehensive transfer guide with examples

### Helper Scripts
- `authorize_gdrive.sh` - Complete Google Drive authorization
- `complete_box_auth.sh` - Complete Box authorization
- `exchange_auth_code.sh` - Exchange OAuth codes for tokens

## Configured Remotes

After setup, you'll have these remotes available:
- `NoginGoogleDrive:` - Personal Google Drive
- `Finance-SharedDrive:` - Finance shared drive
- `Box:` - Box.com storage

## Common Commands

### List files in a remote
```bash
rclone lsd RemoteName:
```

### Copy files
```bash
rclone copy Source:Path Dest:Path --progress
```

### Sync directories (be careful - deletes files in destination)
```bash
rclone sync Source:Path Dest:Path --dry-run  # Test first
rclone sync Source:Path Dest:Path --progress  # Actually sync
```

### Check file sizes
```bash
rclone size RemoteName:Path
```

## WebUI Access

### Option 1: Enhanced Transfer UI (Recommended)

We've created a custom transfer UI with better file browsing and transfer capabilities:

```bash
./start-transfer-ui.sh
```

Access at: http://localhost:8080

Features:
- Dual-pane file browser
- Select multiple files for transfer
- Visual transfer queue
- Easy navigation between folders

### Option 2: Standard rclone WebUI

Start the standard rclone WebUI:
```bash
rclone rcd --rc-web-gui --rc-user=admin --rc-pass=admin --rc-addr=:5572
```

Access at: http://localhost:5572

## Documentation

See the `docs/` folder for detailed guides:
- `webui_transfer_guide.md` - How to use the WebUI for transfers
- `rclone_webui_guide.md` - WebUI navigation guide
- `manual_auth_instructions.txt` - Manual OAuth authorization steps

## Troubleshooting

### Port 53682 in use
This port is used for OAuth callbacks. If you get this error, either:
1. Kill the process using the port
2. Use manual authorization method (see docs)

### Box token expired
Re-run the Box authorization:
```bash
rclone config reconnect Box:
```

### Can't see files in WebUI
1. Clear browser cache
2. Try incognito/private browsing mode
3. Restart the WebUI service

## Security Notes

- Keep your OAuth credentials secure
- Use strong passwords for WebUI access
- Be careful with sync operations (they can delete files)
- Always test with --dry-run first

## License

This project is provided as-is for personal use.