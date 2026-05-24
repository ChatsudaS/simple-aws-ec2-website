#!/bin/bash
# Update system packages and restart Nginx
# Author: Chatsuda

echo "Updating system packages..."
dnf update -y

echo "Restarting Nginx..."
systemctl restart nginx

echo "Done. Nginx status:"
systemctl status nginx | head -n 5
