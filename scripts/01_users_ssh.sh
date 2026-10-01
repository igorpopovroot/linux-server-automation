#!/bin/bash

set -euo pipefail

### Creating users, modifying access rights, and SSH configuration/security ###


### Global variable (Constanta)

NEW_USER="deploy"

# Who_am_i

if [[ "$EUID" -ne 0 ]]; then
    echo "WARNING! Launch the script as superuser!"
    exit 1
fi


# Function Creating_new_user/Does the user exist?

create_user() {

	if id "$NEW_USER" &>/dev/null; then
	   echo "User $NEW_USER already exists, skipping"
	else
           useradd -m -s /bin/bash "$NEW_USER"
	   echo "The user $NEW_USER was created"
	fi

}

create_user


# Add user to group with SUDO.

grant_sudo() {

	usermod -aG sudo "$NEW_USER"

}

grant_sudo

# Function for ssh-connection.

setup_ssh_key() {

	mkdir -p "/home/$NEW_USER/.ssh"
	PUBKEY=$(cat "/home/$SUDO_USER/.ssh/authorized_keys")
	echo "$PUBKEY" > "/home/$NEW_USER/.ssh/authorized_keys"
	chmod 700 "/home/$NEW_USER/.ssh"
	chmod 600 "/home/$NEW_USER/.ssh/authorized_keys"
	chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER/.ssh"
}

setup_ssh_key

# Protection SSH access.

harden_ssh() {

local SSHD_HARDENING_CONF="/etc/ssh/sshd_config.d/00-hardening.conf"
	echo "PermitRootLogin no" > "$SSHD_HARDENING_CONF"
	echo "PasswordAuthentication no" >> "$SSHD_HARDENING_CONF"
	systemctl reload ssh
}

harden_ssh


