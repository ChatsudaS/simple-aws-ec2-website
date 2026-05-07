# Simple AWS EC2 Website (ChatsudaS)

## Overview
This is a small practice project where I host a simple company website on an AWS EC2 Linux instance using Nginx.  
I built it to practice my skills.

## Architecture
- 1x AWS EC2 instance (Amazon Linux 2023, t3.micro)
- Security group:
  - HTTP (port 80) allowed from anywhere (0.0.0.0/0)
  - SSH (port 22) allowed only from my current IP
- Nginx web server serving a static HTML page
- Bash scripts for maintenance and backups

## What the project does
- Hosts a simple page: **“Welcome to Chatsuda's Simple Company Site”**.
- Makes the site reachable over the internet using the EC2 public IP.
- Provides two small automation scripts:
  - `update_and_restart_nginx.sh` – updates system packages and restarts Nginx.
  - `backup_website.sh` – creates timestamped backups of the website files.

## Steps I followed

### 1. Launch EC2 instance
1. Launched an EC2 instance in the ap-southeast-7 (Asia Pacific) region using **Amazon Linux 2023**.
2. Selected instance type **t3.micro** (Free Tier eligible).
3. Created an SSH key pair (`chatsuda-ec2-key.pem`) and downloaded it.
4. Created a new security group with:
   - HTTP 80 → Anywhere (0.0.0.0/0)
   - SSH 22 → My IP

### 2. Connect and install Nginx
- Connected to the instance using EC2 Instance Connect (browser-based SSH).
- Ran the following commands:

```bash
dnf update -y
dnf install -y nginx
systemctl start nginx
systemctl enable nginx
```

- Replaced the default index page with my own:

```bash
cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Chatsuda DevOps Demo</title>
</head>
<body>
    <h1>Welcome to Chatsuda's Simple Company Site</h1>
    <p>This site is hosted on an AWS EC2 Linux server using Nginx.</p>
</body>
</html>
EOF

systemctl restart nginx
```

### 3. Add maintenance and backup scripts

```bash
cat > update_and_restart_nginx.sh << 'EOF'
#!/bin/bash
echo "Updating system packages..."
dnf update -y

echo "Restarting Nginx..."
systemctl restart nginx

echo "Done. Nginx status:"
systemctl status nginx | head -n 5
EOF

chmod +x update_and_restart_nginx.sh
```

```bash
cat > backup_website.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=/home/ec2-user/site-backups
SOURCE_DIR=/usr/share/nginx/html

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/site-backup-$TIMESTAMP.tar.gz"

echo "Creating backup at $BACKUP_FILE ..."
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

echo "Backup complete."
ls -lh "$BACKUP_DIR"
EOF

chmod +x backup_website.sh
```

### 4. Security hardening
- After finishing the setup, I changed the SSH rule in the security group back from `0.0.0.0/0` to **My IP** only.
- This keeps the website public but restricts admin access to my own address.

## How to reuse this project
Anyone can recreate this project by:
1. Launching an EC2 instance with Amazon Linux.
2. Opening HTTP (80) to the world and SSH (22) from their own IP.
3. Installing Nginx and replacing the default HTML file.
4. Adding their own bash scripts for maintenance and backups.
