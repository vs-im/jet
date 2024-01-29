#!/bin/bash

# Check if the script is run with sudo privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run with sudo privileges" 1>&2
   exit 1
fi

# Set the username
username="jet"

# Create a new user without a password
adduser --disabled-password --gecos "" $username

# Add the user to the sudo group
usermod -aG sudo $username

# Create the .ssh directory for the user
mkdir -p /home/$username/.ssh
chown $username:$username /home/$username/.ssh
chmod 700 /home/$username/.ssh

# Generate SSH keys with specified extensions
sudo -u $username ssh-keygen -t rsa -b 4096 -m PEM -N '' -f /home/$username/.ssh/$username.key
if [ $? -eq 0 ]; then
    echo "SSH keys successfully created."
else
    echo "Error creating SSH keys."
    exit 1
fi

# Copy the public key (with .key.pub extension) to authorized_keys
cat /home/$username/.ssh/$username.key.pub > /home/$username/.ssh/authorized_keys
chown $username:$username /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys

# Set correct permissions for files
chmod 600 /home/$username/.ssh/$username.key

# Enable SSH server if it's not installed
# apt-get install -y openssh-server
# systemctl enable ssh
# systemctl start ssh

echo "User $username created. SSH keys are located in /home/$username/.ssh/"
