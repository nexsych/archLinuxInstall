echo "# Time zone"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

echo "# Localization"
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf

echo "# Network configuration"
echo "Hostname?"
read hostname
echo $hostname > /etc/hostname
systemctl enable NetworkManager

echo "# Root password"
passwd

echo "# Bootloader and microcode"
pacman -S grub efibootmgr intel-ucode
grub-install --target=x86_64-efi --booloader-id=grub --efi-directory=/boot
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


echo "## Post-installation"
# Required programs"
pacman -S zsh polkit xdg-user-dirs pipewire wireplumber pipewire-alsa pipewire-jack pipewire-pulse pamixer xorg-server xorg-xinit xorg-xrandr xcompmgr xwallpaper python-pywal redshift libnotify dunst sxhkd slock unclutter rsync fzf tree unzip maim sxiv mpv git wget firefox noto-fonts ttf-jetbrains-mono ttf-font-awesome arc-gtk-theme man-db

echo "# Non-root user"
echo "Non-root user's username?"
read nusr
useradd -m -G wheel -s $(which zsh) $nusr
passwd $nusr
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


echo "## Reboot"
