#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You must be root to do this"
    exit
fi

# List of users and their public SSH keys
declare -A USERS
USERS=(
    ["user"]="ssh-ed25519 AAAAAAAAAAAAAAAAAAAA name@example.com"
)

# Function to create user and set up SSH key
create_user() {
    local USERNAME=$1
    local SSH_KEY=$2

    # Create user if it doesn't exist
    if id "$USERNAME" &>/dev/null; then
        echo "User $USERNAME already exists. Continuing..."
    else
        echo "Creating user $USERNAME..."
        useradd -m -s /bin/bash "$USERNAME"
    fi

    # Add user to group sudo
    usermod -aG sudo "$USERNAME"

    # Create .ssh directory if it doesn't exist
    mkdir -p /home/"$USERNAME"/.ssh

    # Set permissions for .ssh directory
    chmod 700 /home/"$USERNAME"/.ssh

    # Add the public key to the authorized_keys file
    echo "$SSH_KEY" | sudo tee /home/"$USERNAME"/.ssh/authorized_keys > /dev/null

    # Set permissions for the authorized_keys file
    chmod 600 /home/"$USERNAME"/.ssh/authorized_keys
    chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

    echo "User $USERNAME created and configured for SSH access."
}

# Iterate over users and create each one
for USERNAME in "${!USERS[@]}"; do
    SSH_KEY=${USERS[$USERNAME]}
    create_user "$USERNAME" "$SSH_KEY"
done

echo "User initialization complete."
