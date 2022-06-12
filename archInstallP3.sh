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
