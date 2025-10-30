#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
apt update && apt upgrade -y

# Install required packages
apt install -y curl ssh-import-id

# Create a new user 'svc_docker' with home directory
useradd -m -s /bin/bash svc_docker

# Set password for the new user
echo "============================================"
echo "Please set a password for user 'svc_docker'"
echo "You will be prompted to enter it twice..."
echo "============================================"
passwd svc_docker

# Create additional directories for the user
echo "Creating additional directories for svc_docker..."
mkdir -p /home/svc_docker/{scripts,logs,config}
chown -R svc_docker:svc_docker /home/svc_docker/{scripts,logs,config}
chmod 755 /home/svc_docker/{scripts,logs,config}

# Import SSH keys from GitHub for the user
echo "============================================"
echo "Import SSH keys from GitHub for svc_docker"
echo "Enter GitHub username (or press Enter to skip):"
echo "============================================"
read -p "GitHub username: " github_username

if [ ! -z "$github_username" ]; then
    echo "Importing SSH keys for GitHub user: $github_username"
    # Run ssh-import-id-gh as the svc_docker user
    sudo -u svc_docker ssh-import-id-gh "$github_username"
    echo "SSH keys imported successfully!"
else
    echo "Skipping SSH key import."
fi

# Optionally, you can add the user to the docker group if Docker is installed later
# usermod -aG docker svc_docker

echo "Setup complete. User 'svc_docker' created with password and directories."
``