printf '\033c'


echo "## Pre-installation"
echo "# Connect to the internet"
ping -c 5 archlinux.org

echo "# Update the system clock"
timedatectl set-ntp true

echo "# Partition the disk"
lsblk
echo "Which disk? (Create partition in order: EFI, swap, main)"
read disk
fdisk $disk

echo "# Format the partitions"
mkfs.ext4 "$disk"3
mkswap "$disk"2
mkfs.fat -F 32 "$disk"1

echo "# Mount the file systems"
mount "$disk"3 /mnt
mount --mkdir "$disk"1 /mnt/boot
swapon "$disk"2


echo "## Installation"
echo "# Install essential packages"
pacstrap /mnt base linux linux-firmware base-devel neovim networkmanager


echo "## Configure the system"
echo "# Fstab"
genfstab -U /mnt >> /mnt/etc/fstab
