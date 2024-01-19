#!/bin/bash

step() {
    local percentage=$1
    local message=$2
    local bar_length=$((percentage / 2))
    local bar=$(printf "%-${bar_length}s" | tr ' ' '#')
    local percentage_text="\e[1;32m($percentage%)\e[0m"

    echo -e "\r\e[1;32m[+] \e[0m$message\n$bar $percentage_text"
    sleep 1
}

total_step=8
#current_step=0

for ((current_step = 1; current_step <= total_steps; current_step++)); do
    step $current_step $total_steps
    sleep 1
done

# Base
exec 1>&3 2>&4
((current_step++))
step 10 "Installing base"
sleep 1
exec 3>&1 4>&2 1>/dev/null 2>&1
sudo apt update && sudo apt upgrade -y

sudo apt-get install -y arandr flameshot arc-theme feh i3blocks i3status i3 i3-wm lxappearance python3-pip rofi unclutter cargo compton papirus-icon-theme imagemagick
sudo apt-get install -y libxcb-shape0-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev autoconf meson
sudo apt-get install -y libxcb-render-util0-dev libxcb-shape0-dev libxcb-xfixes0-dev
sudo apt-get install -y curl vim zsh code

# Fonts
exec 1>&3 2>&4
((current_step++))
step 25 "Installing fonts"
sleep 1
exec 3>&1 4>&2 1>/dev/null 2>&1
mkdir -p ~/.local/share/fonts/

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip

unzip Iosevka.zip -d ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/

fc-cache -fv

# Alacritty
exec 1>&3 2>&4
((current_step++))
step 40 "Installing alacritty"
exec 3>&1 4>&2 1>/dev/null 2>&1
wget https://github.com/barnumbirr/alacritty-debian/releases/download/v0.10.0-rc4-1/alacritty_0.10.0-rc4-1_amd64_bullseye.deb
sudo dpkg -i alacritty_0.10.0-rc4-1_amd64_bullseye.deb
sudo apt install -f

# Fzf
exec 1>&3 2>&4
((current_step++))
step 50 "Installing fzf"
exec 3>&1 4>&2 1>/dev/null 2>&1
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Docker
exec 1>&3 2>&4
((current_step++))
step 55 "Installing docker"
exec 3>&1 4>&2 1>/dev/null 2>&1
curl -fsSL "https://get.docker.com/" -o get-docker.sh
sh get-docker.sh

# Exegol
exec 1>&3 2>&4
((current_step++))
step 75 "Installing exegol"
exec 3>&1 4>&2 1>/dev/null 2>&1
python3 -m pip install exegol
sudo usermod -aG docker $(id -u -n)
newgrp docker
export PATH="$HOME/.local/bin:$PATH"

# VScode
exec 1>&3 2>&4
((current_step++))
step 80 "Installing vscode"
exec 3>&1 4>&2 1>/dev/null 2>&1
sudo snap install --classic code
cp ~/vscode/settings.json ~/.config/Code/User/settings.json
cp -r /vscode/extensions/ ~/.vscode/extensions/

exec 1>&3 2>&4
((current_step++))
step 90 "Env settings"
exec 3>&1 4>&2 1>/dev/null 2>&1
# Env desktop color
pip3 install pywal

# WM and more
mkdir -p ~/.config/i3
mkdir -p ~/.config/compton
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
cp .config/i3/config ~/.config/i3/config
cp .config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp .config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf
cp .config/compton/compton.conf ~/.config/compton/compton.conf
cp .config/rofi/config ~/.config/rofi/config
cp .fehbg ~/.fehbg
cp .config/i3/clipboard_fix.sh ~/.config/i3/clipboard_fix.sh
cp -r .wallpaper ~/.wallpaper

# i3-gaps
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps && mkdir -p build && cd build && meson ..
ninja
sudo ninja install
cd ../..

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/plugins/zsh-completions
#git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
exec 1>&3 2>&4
((current_step++))
step 100 "Installation complete! :)"
exec 3>&1 4>&2 1>/dev/null 2>&1
