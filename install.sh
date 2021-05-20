#!/bin/bash

set -e

loadkeys trq
cd /

reflector -c Turkey -a 24 --sort rate --save /etc/pacman.d/mirrorlist

lsblk

read -t 180 -r -s -p "### WARNING ### Formatting /dev/sda5 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda5
echo "Formatted /dev/sda5"

read -t 60 -r -s -p "### WARNING ### Formatting /dev/sda6 as BTRFS enter to continue, ctrl + c to break"
mkfs.btrfs -f /dev/sda6
echo "Formatted /dev/sda6"

mount /dev/sda5 /mnt
mkdir mnthome
mount /dev/sda6 /mnthome
btrfs su cr /mnt/@
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var
btrfs su cr /mnthome/@home
umount /mnthome
umount /mnt
rm -r /mnthome

mount -o noatime,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,var}
mount /dev/sda1 /mnt/boot
mount -o noatime,space_cache=v2,subvol=@home /dev/sda6 /mnt/home
mount -o noatime,space_cache=v2,subvol=@var /dev/sda5 /mnt/var

set +e
sleep 1

pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode neovim git reflector
sleep 1
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
sleep 1
read -t 10 -r -s -p "chaging root to /mnt enter to continue ctrl + c to break"
sleep 1
arch-chroot /mnt
arch-chroot /mnt
sleep 1
arch-chroot /mnt
