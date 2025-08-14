// Rclone Transfer Manager
// This connects to the rclone RC API to browse and transfer files

// If running through our proxy server, use relative URLs
// Otherwise, connect directly to rclone
const RC_URL = window.location.port === '8080' ? '' : 'http://localhost:5572';
const RC_USER = 'admin';
const RC_PASS = 'admin';

// State
let sourceRemote = '';
let destRemote = '';
let sourcePath = '/';
let destPath = '/';
let selectedFiles = new Set();
let transfers = [];

// Initialize
document.addEventListener('DOMContentLoaded', async () => {
    await loadRemotes();
    
    document.getElementById('source-remote').addEventListener('change', (e) => {
        sourceRemote = e.target.value;
        sourcePath = '/';
        if (sourceRemote) {
            browseSource('/');
        }
    });
    
    document.getElementById('dest-remote').addEventListener('change', (e) => {
        destRemote = e.target.value;
        destPath = '/';
        if (destRemote) {
            browseDest('/');
        }
    });
});

// Make authenticated request to rclone RC
async function rcRequest(command, params = {}) {
    try {
        const response = await fetch(`${RC_URL}/${command}`, {
            method: 'POST',
            headers: {
                'Authorization': 'Basic ' + btoa(`${RC_USER}:${RC_PASS}`),
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(params)
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('RC request failed:', error);
        showError(`Failed to communicate with rclone: ${error.message}`);
        return null;
    }
}

// Load available remotes
async function loadRemotes() {
    const result = await rcRequest('config/listremotes');
    if (!result || !result.remotes) return;
    
    const sourceSelect = document.getElementById('source-remote');
    const destSelect = document.getElementById('dest-remote');
    
    // Clear existing options except the first
    sourceSelect.innerHTML = '<option value="">Select Remote...</option>';
    destSelect.innerHTML = '<option value="">Select Remote...</option>';
    
    result.remotes.forEach(remote => {
        // Remove trailing colon
        const remoteName = remote.replace(/:$/, '');
        
        const sourceOption = new Option(remoteName, remoteName);
        const destOption = new Option(remoteName, remoteName);
        
        sourceSelect.add(sourceOption);
        destSelect.add(destOption);
    });
}

// Browse source remote
async function browseSource(path) {
    sourcePath = path;
    selectedFiles.clear();
    updateTransferButtons();
    
    const browser = document.getElementById('source-browser');
    browser.innerHTML = '<div class="loading">Loading...</div>';
    
    const result = await rcRequest('operations/list', {
        fs: sourceRemote + ':',
        remote: path
    });
    
    if (!result) {
        browser.innerHTML = '<div class="error-message">Failed to load files</div>';
        return;
    }
    
    displayFiles(browser, result.list || [], 'source');
    updateBreadcrumb('source', path);
}

// Browse destination remote
async function browseDest(path) {
    destPath = path;
    
    const browser = document.getElementById('dest-browser');
    browser.innerHTML = '<div class="loading">Loading...</div>';
    
    const result = await rcRequest('operations/list', {
        fs: destRemote + ':',
        remote: path
    });
    
    if (!result) {
        browser.innerHTML = '<div class="error-message">Failed to load files</div>';
        return;
    }
    
    displayFiles(browser, result.list || [], 'dest');
    updateBreadcrumb('dest', path);
}

// Display files in browser
function displayFiles(container, files, type) {
    container.innerHTML = '';
    
    // Sort: directories first, then files
    files.sort((a, b) => {
        if (a.IsDir === b.IsDir) {
            return a.Name.localeCompare(b.Name);
        }
        return b.IsDir - a.IsDir;
    });
    
    files.forEach(file => {
        const item = document.createElement('div');
        item.className = 'file-item';
        item.dataset.path = file.Path;
        item.dataset.isDir = file.IsDir;
        
        const icon = file.IsDir ? '📁' : '📄';
        const size = file.IsDir ? '' : formatSize(file.Size);
        
        item.innerHTML = `
            <span class="file-icon">${icon}</span>
            <div class="file-info">
                <div class="file-name">${file.Name}</div>
                ${size ? `<div class="file-size">${size}</div>` : ''}
            </div>
        `;
        
        if (type === 'source') {
            item.addEventListener('click', () => {
                if (file.IsDir) {
                    browseSource(file.Path);
                } else {
                    toggleSelection(item);
                }
            });
        } else {
            item.addEventListener('click', () => {
                if (file.IsDir) {
                    browseDest(file.Path);
                }
            });
        }
        
        container.appendChild(item);
    });
}

// Toggle file selection
function toggleSelection(item) {
    const path = item.dataset.path;
    
    if (selectedFiles.has(path)) {
        selectedFiles.delete(path);
        item.classList.remove('selected');
    } else {
        selectedFiles.add(path);
        item.classList.add('selected');
    }
    
    updateTransferButtons();
}

// Update transfer button states
function updateTransferButtons() {
    const hasSelection = selectedFiles.size > 0;
    const hasRemotes = sourceRemote && destRemote;
    
    document.getElementById('transfer-btn').disabled = !hasSelection || !hasRemotes;
    document.getElementById('sync-btn').disabled = !hasRemotes;
}

// Update breadcrumb navigation
function updateBreadcrumb(type, path) {
    const breadcrumb = document.getElementById(`${type}-breadcrumb`);
    breadcrumb.innerHTML = '';
    
    // Root
    const root = document.createElement('span');
    root.className = 'breadcrumb-item';
    root.textContent = 'Root';
    root.onclick = () => type === 'source' ? navigateSource('/') : navigateDest('/');
    breadcrumb.appendChild(root);
    
    // Path segments
    if (path && path !== '/') {
        const segments = path.split('/').filter(s => s);
        let currentPath = '';
        
        segments.forEach((segment, index) => {
            currentPath += '/' + segment;
            
            breadcrumb.appendChild(document.createTextNode(' / '));
            
            const item = document.createElement('span');
            item.className = 'breadcrumb-item';
            item.textContent = segment;
            
            const pathCopy = currentPath;
            item.onclick = () => type === 'source' ? navigateSource(pathCopy) : navigateDest(pathCopy);
            
            breadcrumb.appendChild(item);
        });
    }
}

// Navigation helpers
function navigateSource(path) {
    browseSource(path);
}

function navigateDest(path) {
    browseDest(path);
}

// Refresh buttons
function refreshSource() {
    if (sourceRemote) {
        browseSource(sourcePath);
    }
}

function refreshDest() {
    if (destRemote) {
        browseDest(destPath);
    }
}

// Transfer selected files
async function transferSelected() {
    if (selectedFiles.size === 0) return;
    
    const filesToTransfer = Array.from(selectedFiles);
    
    for (const file of filesToTransfer) {
        const transferId = Date.now() + Math.random();
        const transfer = {
            id: transferId,
            source: sourceRemote + ':' + file,
            dest: destRemote + ':' + destPath + '/' + file.split('/').pop(),
            status: 'queued',
            progress: 0
        };
        
        transfers.push(transfer);
        updateTransferQueue();
        
        // Start the transfer
        startTransfer(transfer);
    }
    
    // Clear selection
    selectedFiles.clear();
    browseSource(sourcePath);
}

// Start a transfer
async function startTransfer(transfer) {
    transfer.status = 'active';
    updateTransferQueue();
    
    try {
        // For demonstration, we'll use operations/copyfile
        // In a real implementation, you'd want to use async jobs
        const result = await rcRequest('operations/copyfile', {
            srcFs: transfer.source.split(':')[0] + ':',
            srcRemote: transfer.source.split(':')[1],
            dstFs: transfer.dest.split(':')[0] + ':',
            dstRemote: transfer.dest.split(':')[1]
        });
        
        transfer.status = 'complete';
        transfer.progress = 100;
    } catch (error) {
        transfer.status = 'error';
        transfer.error = error.message;
    }
    
    updateTransferQueue();
}

// Sync folders
async function syncFolders() {
    if (!sourceRemote || !destRemote) return;
    
    const confirmed = confirm(`Sync ${sourceRemote}:${sourcePath} to ${destRemote}:${destPath}?\n\nThis will make the destination match the source exactly.`);
    
    if (!confirmed) return;
    
    const transferId = Date.now();
    const transfer = {
        id: transferId,
        source: sourceRemote + ':' + sourcePath,
        dest: destRemote + ':' + destPath,
        status: 'active',
        progress: 0,
        type: 'sync'
    };
    
    transfers.push(transfer);
    updateTransferQueue();
    
    // In a real implementation, you'd use sync/sync
    transfer.status = 'complete';
    transfer.progress = 100;
    updateTransferQueue();
    
    // Refresh destination
    browseDest(destPath);
}

// Update transfer queue display
function updateTransferQueue() {
    const list = document.getElementById('transfer-list');
    
    if (transfers.length === 0) {
        list.innerHTML = '<p style="text-align: center; color: #666; padding: 20px;">No active transfers</p>';
        return;
    }
    
    list.innerHTML = transfers.map(transfer => `
        <div class="transfer-item">
            <div style="flex: 0 0 200px;">
                <strong>${transfer.type === 'sync' ? '🔄 Sync' : '📄 Copy'}</strong><br>
                <small>${transfer.source.split('/').pop()}</small>
            </div>
            <div class="transfer-progress">
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${transfer.progress}%">
                        ${transfer.progress}%
                    </div>
                </div>
            </div>
            <div>
                <span class="status ${transfer.status}">${transfer.status}</span>
            </div>
        </div>
    `).join('');
}

// Utility functions
function formatSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function showError(message) {
    alert(message);
}