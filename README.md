# linux-server-automation

Bash scripts that provision a fresh Ubuntu Server 24.04 from scratch: users and SSH hardening, LVM storage, nginx web server with a firewall, and nightly backups with rotation. A portfolio project in Linux server administration.


## Scripts

- `01_users_ssh.sh` — creates the `deploy` user, grants sudo, sets up SSH key access and hardens SSH (disables root login and password authentication).
- `02_lvm_setup.sh` — combines two disks (`/dev/sdb`, `/dev/sdc`) into one LVM volume: creates PV → VG → LV, formats it as ext4, mounts it to `/mnt/data` and adds an `/etc/fstab` entry so it survives a reboot.
- `03_nginx_setup.sh` — installs and enables nginx, configures the UFW firewall (ports 22 and 80) and deploys the site from `site/`.
- `04_backup.sh` — archives the nginx configuration and the site with tar into `/mnt/data/backups`, checks the archive and deletes archives older than 7 days.
- `monitor_memory.sh` — checks available RAM against WARNING / CRITICAL thresholds.

## Features

- **Strict mode** — every script starts with `set -euo pipefail`: stops on any error, on unset variables and on failures inside pipes.
- **Idempotent** — safe to run again: each step checks whether it is already done (`id`, `pvs`, `vgs`, `lvs`, `blkid`, `findmnt`, `grep`) and skips it.
- **Root check** — scripts refuse to run without root privileges.
- **Secure by default** — key-only SSH login, no root login, `~/.ssh` 700 / `authorized_keys` 600.

## Requirements

- Ubuntu Server 24.04
- root privileges (`sudo`)
- for `02_lvm_setup.sh`: two empty disks `/dev/sdb` and `/dev/sdc`

> ⚠️ `02_lvm_setup.sh` formats `/dev/sdb` and `/dev/sdc` — all data on them will be lost.

## Usage

```bash
git clone git@github.com:igorpopovroot/linux-server-automation.git
cd linux-server-automation
sudo bash scripts/01_users_ssh.sh
sudo bash scripts/02_lvm_setup.sh
sudo bash scripts/03_nginx_setup.sh
sudo bash scripts/04_backup.sh
```

## Nightly backup (systemd)

`systemd/backup.service` runs `04_backup.sh`, `systemd/backup.timer` starts it every night at 03:00 (Europe/Moscow).
Note: `ExecStart` in `backup.service` points to `/home/redman/linux-server-automation/scripts/04_backup.sh` — change the path if you clone the repository elsewhere.

```bash
sudo cp systemd/backup.service systemd/backup.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
```
## Roadmap


- [x] Users and SSH hardening
- [x] LVM storage
- [x] `03_nginx_setup.sh` — web server and firewall
- [x] `04_backup.sh` — backups with tar, rotation and a systemd timer
- [ ] Restore test for backups
- [ ] `05_docker_setup.sh` — Docker
- [ ] Ansible roles and CI (ShellCheck)

Tested on Ubuntu Server 24.04 (VirtualBox).
