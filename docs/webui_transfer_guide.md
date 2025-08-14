# rclone WebUI Transfer Guide

## After logging in to the WebUI:

### Step 1: Navigate to Explorer
- Click on "Explorer" in the left sidebar (it might also be called "Remote Explorer")
- You should see your remotes listed:
  - NoginGoogleDrive
  - Box
  - Finance-SharedDrive
  - GDrive-AllShared

### Step 2: Browse the Finance Shared Drive
1. Click on "Finance-SharedDrive" to expand it
2. You'll see all the folders (Banking, AP, AR, etc.)
3. Navigate to the folder you want to transfer

### Step 3: Select Files/Folders to Transfer
- Check the boxes next to the folders/files you want to transfer
- You can select multiple items

### Step 4: Copy to Box
1. After selecting items, look for the "Copy" or "Transfer" button (usually at the top)
2. A dialog will appear asking for the destination
3. Select "Box:" as the destination
4. Choose or create a folder in Box (e.g., "Finance-Backup")
5. Click "Copy" or "Start Transfer"

### Step 5: Monitor Progress
- The WebUI will show transfer progress
- You can see speed, ETA, and files being transferred
- Transfers continue even if you close the browser

## Alternative Method - Jobs/Tasks:
1. Go to "Jobs" or "Tasks" in the sidebar
2. Click "New Job" or "Create Task"
3. Set:
   - Source: Finance-SharedDrive:/FolderName
   - Destination: Box:/Finance-Backup/FolderName
   - Operation: Copy
4. Start the job

## Tips:
- Start with a small folder to test
- Use "Sync" instead of "Copy" if you want to mirror exactly
- Check "Dry Run" first to see what will be transferred without actually doing it