#!/bin/bash

### Strict mode

set -euo pipefail

### Who_am_i?

if [[ "$EUID" -ne 0 ]]; then
    echo "WARNING! Launch the script as superuser!"
    exit 1
fi

### Variables
## What we are backup? (nginx.conf/site)
BACKUP_SRC="/etc/nginx /var/www/html"

## Where do we put it?
BACKUP_DST="/mnt/data/backups"

ARCHIVE="$BACKUP_DST/backup_$(date +%F_%H-%M-%S).tar.gz"


### func: create backup

create_backup() {

mkdir -p "$BACKUP_DST"
tar -czf "$ARCHIVE" $BACKUP_SRC
echo "Backup $ARCHIVE created"


}

create_backup


### func: check archive(exist and is not empty)

check_archive() {

if [[ ! -s "$ARCHIVE" ]]; then
    echo "WARNING! Archive not found or its size is zero"
    exit 1
else
    echo "Archive successfully located. Checking complex files inside..."
    echo "--------------------------------------------------------------"
fi

}

check_archive

### func: show contents of archive (first 10 files)

archive_contents() {

tar -tzf "$ARCHIVE" | head -n 10

# Check: exitcode of the tar command

if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
    echo "WARNING! Archive $ARCHIVE is damaged!"
else
    echo "The archive is not empty; displaying the first 10 files..."
fi

}

archive_contents




