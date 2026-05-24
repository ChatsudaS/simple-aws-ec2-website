#!/bin/bash
# Backup website files with timestamp
# Author: Chatsuda

BACKUP_DIR=/home/ec2-user/site-backups
SOURCE_DIR=/usr/share/nginx/html

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/site-backup-$TIMESTAMP.tar.gz"

echo "Creating backup at $BACKUP_FILE ..."
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

echo "Backup complete."
ls -lh "$BACKUP_DIR"
