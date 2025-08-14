# Rclone WebUI File Transfer Guide

## Navigation in the WebUI

### 1. Access the Explorer
After logging in (admin/admin), look for these options in the menu:
- **Explorer** or **Browse** or **Files** 
- It might be an icon that looks like a folder

### 2. If you don't see file browsing options:

The WebUI might be showing a simplified interface. Try:

1. **Look for a hamburger menu** (three lines ☰) in the top left
2. **Check for tabs** at the top of the page
3. **Look for icons** in a sidebar

### 3. Alternative: Use the RC (Remote Control) Interface

If the GUI isn't showing file operations, you can use the RC commands:

1. Look for **"RC"** or **"Remote Control"** in the menu
2. Or navigate to: http://localhost:5572/rc
3. Use these commands:

**To list files:**
- Command: `operations/list`
- Parameters:
  ```json
  {
    "fs": "Finance-SharedDrive:",
    "remote": ""
  }
  ```

**To copy files:**
- Command: `sync/copy`
- Parameters:
  ```json
  {
    "srcFs": "Finance-SharedDrive:FolderName",
    "dstFs": "Box:Finance-Backup/FolderName"
  }
  ```

### 4. Direct API Calls

You can also trigger transfers directly by visiting:
http://localhost:5572/[rc-endpoint]

With proper parameters in the URL or as POST data.