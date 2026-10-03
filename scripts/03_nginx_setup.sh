#!/bin/bash

### Strict mode

set -euo pipefail

# Who_am_i

if [[ "$EUID" -ne 0 ]]; then
    echo "WARNING! Launch the script as superuser!"
    exit 1
fi

### Variables

WEB_ROOT="/var/www/html"
SITE_SRC="site/index.html"


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

### func: configure_firewall

configure_firewall() {

ufw allow 22/tcp
ufw allow 80/tcp

ufw --force enable
echo "Allowed firewall ports: 80 and 22"

}

configure_firewall

### func: deploy_site

deploy_site() {

cp "$SITE_SRC" "$WEB_ROOT/index.html"
chown root:root "$WEB_ROOT/index.html"
chmod 644 "$WEB_ROOT/index.html"
echo "Site deployed to $WEB_ROOT"

}

deploy_site
