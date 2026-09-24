#!/bin/bash

# Default user and password if environment variables aren't set
SSH_USER=${SSH_USER:-"railway"}
SSH_PASS=${SSH_PASS:-"ChangeMe123!"}

# Create user if not exists
if ! id "$SSH_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$SSH_USER"
    echo "$SSH_USER:$SSH_PASS" | chpasswd
    usermod -aG sudo "$SSH_USER"
    echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Add SSH Public Key if provided via variable
if [ -n "$SSH_PUBLIC_KEY" ]; then
    USER_HOME=$(eval echo "~$SSH_USER")
    mkdir -p "$USER_HOME/.ssh"
    echo "$SSH_PUBLIC_KEY" > "$USER_HOME/.ssh/authorized_keys"
    chmod 700 "$USER_HOME/.ssh"
    chmod 600 "$USER_HOME/.ssh/authorized_keys"
    chown -R "$SSH_USER:$SSH_USER" "$USER_HOME/.ssh"
fi

# Generate host keys if missing
ssh-keygen -A

# Start SSH server in foreground
exec /usr/sbin/sshd -D
