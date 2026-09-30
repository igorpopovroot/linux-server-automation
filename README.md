# linux-server-automation

Bash scripts that provision a fresh Ubuntu Server 24.04 from scratch: users, SSH hardening and LVM storage. A learning / portfolio project on the way to Linux administration and DevOps.

## Scripts

- `01_users_ssh.sh` — creates the `deploy` user, grants sudo, sets up SSH key access and hardens SSH (disables root login and password authentication).
- `02_lvm_setup.sh` — combines two disks (`/dev/sdb`, `/dev/sdc`) into one LVM volume: creates PV → VG → LV, formats it as ext4, mounts it to `/mnt/data` and adds an `/etc/fstab` entry so it survives a reboot.

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
```

## Known limitations

- `01_users_ssh.sh` copies the SSH public key from `/home/redman/.ssh/authorized_keys` (hardcoded — to be made configurable).

## Roadmap

- [x] Users and SSH hardening
- [x] LVM storage
- [ ] `03_nginx_setup.sh` — web server and firewall
- [ ] `04_backup.sh` — backups with tar/rsync and cron
- [ ] `05_docker_setup.sh` — Docker
- [ ] Ansible roles and CI (ShellCheck)

Tested on Ubuntu Server 24.04 (VirtualBox).
