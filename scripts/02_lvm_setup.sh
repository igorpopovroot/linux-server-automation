#!/bin/bash

set -euo pipefail

### Variables: group_name, logical_volume_name.

VG_NAME="vg_data"
LV_NAME="lv_data"
LV_PATH="/dev/$VG_NAME/$LV_NAME"
MOUNT_POINT="/mnt/data"


# Who_am_i

if [[ "$EUID" -ne 0 ]]; then
    echo "WARNING! Launch the script as superuser!"
    exit 1
fi


### Physical Volume func.

create_pv() {

if pvs /dev/sdb /dev/sdc &>/dev/null; then
	echo "Disks already initialized as PV, skipping..."
else
	pvcreate /dev/sdb /dev/sdc
	echo "PV created on /dev/sdb /dev/sdc"
fi

}

create_pv


### Volume group func.

create_vg() {

if vgs "$VG_NAME" &>/dev/null; then
	echo "VG already created, skipping..."
else
	vgcreate "$VG_NAME" /dev/sdb /dev/sdc
	echo "VG $VG_NAME created"
fi

}

create_vg


### Logical Volume create func.

create_lv() {

if lvs "$VG_NAME/$LV_NAME" &>/dev/null; then
	echo "LV $VG_NAME/$LV_NAME already exists, skipping..."
else
	lvcreate -l 100%FREE -n "$LV_NAME" "$VG_NAME"
	echo "LV $VG_NAME/$LV_NAME created"
fi

}

create_lv


### Formatting lv_path to ext4 func.

format_lv() {

if blkid "$LV_PATH" &>/dev/null; then
	echo "Filesystem already exists on $LV_PATH, skipping..."
else
	mkfs.ext4 "$LV_PATH"
	echo "ext4 created on $LV_PATH"
fi

}

format_lv


### Mounting.

mount_lv()  {

if findmnt "$MOUNT_POINT" &>/dev/null; then
	echo "$MOUNT_POINT already mounted, skipping..."
else
	mkdir -p "$MOUNT_POINT"
	mount "$LV_PATH" "$MOUNT_POINT"
	echo "$LV_PATH mounted to $MOUNT_POINT"
fi

}

mount_lv


### Add fstab.

add_fstab() {

if grep -q "$LV_PATH" "/etc/fstab" &>/dev/null; then
     echo "fstab entry already exists, skipping..."
else
     echo "$LV_PATH" "$MOUNT_POINT" ext4 defaults 0 2 >> /etc/fstab
     systemctl daemon-reload
     echo "fstab entry added"
fi

}

add_fstab
