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
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:nexsych/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/

mkdir -p aud dl doc img/paper vid

ln -s .local/share/wallhaven-l3prel.png img/paper/wallhaven-l3prel.png

# dwmset
git clone git@github.com:nexsych/dwmset.git .local/src/dwmset
cd .local/src/dwmset/dmenu
sudo make clean install

cd ../dwm
sudo make clean install

cd ../dwmblocks
sudo make clean install

cd ../st
sudo make clean install

# yay-bin
cd $HOME/dl
git clone https://aur.archlinux.org/yay-bin.git
cd yay*
makepkg -si
cd ..
rm -rf yay*

# clipmenu

# Supplementary programs
# simple-mtpfs xf86-input-synaptics zathura zathura-pdf-mupdf pinta bc subliminal
