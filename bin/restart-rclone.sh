#!/bin/bash
#
# Restart rclone mount for OneDrive
#

# Unmount if already mounted
if mountpoint -q ~/OneDrive; then
    echo "Unmounting ~/OneDrive..."
    fusermount -u ~/OneDrive
    sleep 1
fi

# Kill any existing rclone processes for OneDrive
if pgrep -f "rclone mount OnedrivePersonal" > /dev/null; then
    echo "Stopping existing rclone processes..."
    pkill -f "rclone mount OnedrivePersonal"
    sleep 1
fi

# Create mount point if it doesn't exist
mkdir -p ~/OneDrive

# Mount OneDrive
echo "Mounting OneDrive..."
rclone mount OnedrivePersonal: ~/OneDrive --vfs-cache-mode full --daemon

# Wait a moment and check if mount was successful
sleep 2
if mountpoint -q ~/OneDrive; then
    echo "✓ OneDrive mounted successfully at ~/OneDrive"
else
    echo "✗ Failed to mount OneDrive"
    exit 1
fi
