#!/usr/bin/env bash

if [ "$(whoami)" != "root" ]; then
    echo "You must be root to do this"
    exit
fi

# Update the system
apt-get update && apt-get upgrade

# Install Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
