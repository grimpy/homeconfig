#!/bin/bash
new_root=$1
mount -o rbind /dev $new_root/dev
mount -o bind /sys $new_root/sys
mount -t proc none $new_root/proc
cp /etc/resolv.conf $new_root/etc
chroot $new_root /bin/bash
umount $new_root/dev
umount $new_root/sys
umount $new_root/proc
