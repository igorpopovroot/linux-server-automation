#!/bin/bash

### Strict mode.

set -euo pipefail

# Who_am_i

if [[ "$EUID" -ne 0 ]]; then
    echo "WARNING! Launch the script as superuser!"
    exit 1
fi

### func: install_nginx

install_nginx() {

if dpkg -s nginx &>/dev/null; then
   echo "Nginx already installed, skipping..."
else
    apt-get update
    apt-get install -y nginx
    echo "Nginx installed"
fi

}

install_nginx

### func: enable_nginx

enable_nginx() {

systemctl enable --now nginx
echo "The service is enabled and added to startup."

}

enable_nginx
