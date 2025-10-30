#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
apt update && apt upgrade -y

# Install required packages
apt install -y curl ssh-import-id 

# Prompt for username
echo "============================================"
echo "Enter username for the new user account"
echo "============================================"
read -p "Username: " username

# Validate username input
if [ -z "$username" ]; then
    echo "Error: Username cannot be empty!"
    exit 1
fi

# Create a new user with home directory
useradd -m -s /bin/bash "$username"

# Set password for the new user
echo "============================================"
echo "Please set a password for user '$username'"
echo "You will be prompted to enter it twice..."
echo "============================================"
passwd "$username"

# Create additional directories for the user
echo "Creating additional directories for $username..."
mkdir -p /home/"$username"/{scripts,logs,config}
chown -R "$username":"$username" /home/"$username"/{scripts,logs,config}
chmod 755 /home/"$username"/{scripts,logs,config}

# Add user to sudoers group
echo "Adding $username to sudoers..."
usermod -aG sudo "$username"

# Import SSH keys from GitHub for the user
echo "============================================"
echo "Import SSH keys from GitHub for $username"
echo "Enter GitHub username (or press Enter to skip):"
echo "============================================"
read -p "GitHub username: " github_username

if [ ! -z "$github_username" ]; then
    echo "Importing SSH keys for GitHub user: $github_username"
    # Run ssh-import-id-gh as the new user
    sudo -u "$username" ssh-import-id-gh "$github_username"
    echo "SSH keys imported successfully!"
else
    echo "Skipping SSH key import."
fi

echo "Setup complete. User '$username' created with password, directories, and sudo privileges."
``
