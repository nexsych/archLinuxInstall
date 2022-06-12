## Pre-installation
### Connect to the internet
Check with `ping`:
```
# ping archlinux.org
```
### Update the system clock
```
# timedatectl set-ntp true
```
### Partition the disks
Layout:
|Mount point|Partition|Partition type|Size|
|-|-|-|-|
|/mnt/boot|/dev/sda1|EFI system partition|550 MiB|
|[SWAP]|/dev/sda2|Linux swap|2 GiB|
|/mnt|/dev/sda3|Linux x86-64 root (/)|Remainder of the disk|
### Format the partitions
```
# mkfs.ext4 /dev/sda3
# mkswap /dev/sda2
# mkfs.fat -F 32 /dev/sda1
```
### Mount the file systems
```
# mount /dev/sda3 /mnt
# mount --mkdir /dev/sda1 /mnt/boot
# swapon /dev/swap_partition
```
## Installation
```
# pacstrap /mnt base linux linux-firmware base-devel neovim networkmanager
```

## Configure the system
### Fstab
```
# genfstab -U /mnt >> /mnt/etc/fstab
```
### Chroot
```
# arch-chroot /mnt
```
### Time zone
```
# ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
# hwclock --systohc
```
### Localization
Uncomment `en_GB.UTF-8 UTF-8` in `/etc/locale.gen`.
```
# locale-gen
# echo "LANG=en_GB.UTF-8" > /etc/locale.conf
```
### Network configuration
```
# echo "r036tu" > /etc/hostname
# systemctl enable NetworkManager
```
### Root password
```
# passwd
```
### Boot loader
```
# pacman -S grub efibootmgr intel-ucode
# grub-install --target=x86_64-efi --booloader-id=grub --efi-directory=/boot
```
Change `GRUB_TIMEOUT` `0` to `5` in `/etc/default/grub`
```
# grub-mkconfig -o /boot/grub/grub.cfg
```
## Post-installation
### Important programs
```
# pacman -S zsh polkit xdg-user-dirs pipewire wireplumber pipewire-alsa pipewire-jack pipewire-pulse pamixer xorg-server xorg-xinit xorg-xrandr xcompmgr xwallpaper python-pywal redshift libnotify dunst sxhkd slock unclutter rsync fzf tree unzip maim sxiv mpv git wget firefox openssh noto-fonts ttf-jetbrains-mono ttf-font-awesome arc-gtk-theme man-db
```
Also install:
```
clipmenu dwmset yay-bin
```
### Supplementary programs
```
simple-mtpfs xf86-input-synaptics zathura zathura-pdf-mupdf bc subliminal
```
