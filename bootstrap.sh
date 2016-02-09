
#! /usr/bin/env bash

SCRIPT_DL_URL="https://www.archlinux.org/mirrorlist/?country=US";

# OS language settings.
echo "Setting up OS languag settings (en_US.UTF8)"
loadkeys us;
setfont lat9w-16;
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen;
locale-gen;
export LANG="en_US.UTF-8 UTF-8";

#create partitions.
echo "Creating partitions";
parted -a optimal --script /dev/sda -- mklabel msdos;
parted -a optimal --script /dev/sda -- mkpart primary ext3 1M 513M;
parted -a optimal --script /dev/sda -- set 1 boot on;
parted -a optimal --script /dev/sda -- mkpart primary linux-swap 513M 2560M;
parted -a optimal --script /dev/sda -- mkpart primary ext4 2560M 100%;

# format swap space and turn it on.
echo "Formatting swap space and activating it...";
mkswap /dev/sda2;
swapon /dev/sda2;

# format boot partition.
echo "Formatting the boot partition as ext3...";
mkfs.ext3 /dev/sda1;

# format storage partition.
echo "Formatting the storage partition as ext4...";
mkfs.ext4 /dev/sda3;

# mount the storage partition.
echo "Mounting the storage partition as /mnt...";
mount /dev/sda3 /mnt;

# mount the boot partition.
echo "Mounting the boot partition as /mnt/boot";
mkdir -p /mnt/boot;
mount /dev/sda1 /mnt/boot;

# get our copy of the mirrorlist.
echo "Downloading a copy of the custom mirrorlist...";
curl -sSL ${SCRIPT_DL_URL} >> mirrorlist.txt;
sed -i -e 's/#Server/Server/g' mirrorlist.txt;
mv mirrorlist.txt /etc/pacman.d/mirrorlist;

# pacstrap: install main system.
echo "Using pacstrap to install base and base-devel packages...";
pacstrap /mnt base base-devel;

# generate fstab;
genfstab -U -p /mnt >> /mnt/etc/fstab;

# chroot
arch-chroot /mnt /bin/bash;

# set language on disk.
echo "Setting language on disk...";
echo en_US.UTF-8 UTF-8 > /etc/locale.gen;

# set language for when we reboot.
echo "Setting local lang...";
echo LANG=en_US.UTF-8 > /etc/locale.conf;
export LANG=en_US.UTF-8;
echo "KEYMAP=de-latin1\nFONT=lat9w-16" > /etc/vconsole.conf;

# setting time zone and updating the clock.
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime;
hwclock --systohc --localtime;

# enable dhcp for when we reboot;
systemctl enable dhcpcd@eno16777736.service;

# install bootloader;
pacman -S --noconfirm grub;
grub-install --target=i386-pc --recheck /dev/sda;
grub-mkconfig -o /boot/grub/grub.cfg;

pacman -S --noconfirm linux-headers;
pacman -S --noconfirm open-vm-tools;

pacman -S --noconfirm openssh;
systemctl enable sshd;

reboot;

