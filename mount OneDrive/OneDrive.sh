#!/usr/bin/bash
echo "Mounting OneDrive....."
rclone --vfs-cache-mode writes mount OneDrive: ~/OneDrive &

