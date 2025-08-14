#!/usr/bin/env python3
"""
Simple web server for Rclone Transfer Manager
Serves the UI and proxies requests to rclone RC
"""

import http.server
import socketserver
import json
import urllib.request
import urllib.error
import base64
from urllib.parse import urlparse
import os

PORT = 8080
RCLONE_URL = "http://localhost:5572"
RCLONE_USER = "admin"
RCLONE_PASS = "admin"

class RcloneProxyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        # Handle CORS
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        
        # If it's an RC command, proxy to rclone
        if self.path.startswith('/operations/') or self.path.startswith('/config/'):
            self.proxy_to_rclone()
        else:
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"error": "Not found"}).encode())
    
    def do_OPTIONS(self):
        # Handle CORS preflight
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()
    
    def proxy_to_rclone(self):
        # Read the request body
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)
        
        # Create request to rclone
        url = RCLONE_URL + self.path
        
        # Basic auth for rclone
        auth_string = f"{RCLONE_USER}:{RCLONE_PASS}"
        auth_bytes = auth_string.encode('ascii')
        auth_b64 = base64.b64encode(auth_bytes).decode('ascii')
        
        headers = {
            'Authorization': f'Basic {auth_b64}',
            'Content-Type': 'application/json'
        }
        
        try:
            req = urllib.request.Request(url, body, headers)
            response = urllib.request.urlopen(req)
            response_data = response.read()
            
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(response_data)
            
        except urllib.error.HTTPError as e:
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_response = {"error": f"Rclone error: {e.code}"}
            self.wfile.write(json.dumps(error_response).encode())
        except Exception as e:
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_response = {"error": str(e)}
            self.wfile.write(json.dumps(error_response).encode())

if __name__ == "__main__":
    # Change to the web-ui directory
    web_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(web_dir)
    
    with socketserver.TCPServer(("", PORT), RcloneProxyHandler) as httpd:
        print(f"Rclone Transfer Manager running at http://localhost:{PORT}")
        print(f"Make sure rclone RC is running at {RCLONE_URL}")
        print("Press Ctrl+C to stop")
        httpd.serve_forever()