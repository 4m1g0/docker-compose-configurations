#!/usr/bin/env bash

if [ "$(whoami)" != "root" ]; then
    echo "You must be root to do this"
    exit
fi

# Update the system
apt-get update && apt-get upgrade

# Install Docker
sudo apt-get install docker-io

# Remove password need for sudo users
chmod +w /etc/sudoers.d/90-cloud-init-users
echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
chmod -w /etc/sudoers.d/90-cloud-init-users

# Create docker user on docker group
adduser --ingroup docker docker

# Make vi the default editor
update-alternatives --set editor /usr/bin/vim.basic

# Add users to the system
./initialize_users.sh
