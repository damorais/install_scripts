#!/bin/bash
sudo dnf upgrade -y
sudo dnf install -y @development-tools @vlc @container-management

# Install tools for development
sudo dnf install ripgrep bat eza btop zoxide -y
# sudo dnf install rust cargo -y
sudo dnf install pkg-config autoconf bison clang rustc openssl openssl-devel openssl-libs readline-devel zlib-devel libyaml-devel libffi-devel gdbm-devel jemalloc-devel vips-devel ImageMagick sqlite postgresql -y

# Install lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

# Configure Shell with ZSH
sudo dnf install zsh -y
chsh -s $(which zsh)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
cp configs/shell/.p10k.zsh ~/.p10k.zsh
cp configs/shell/.zshrc ~/.zshrc

mkdir -p ~/.oh-my-zsh/custom/plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.oh-my-zsh/custom/plugins/you-should-use
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install tools for development - setup zoxide
eval "$(zoxide init zsh)"

# Setup new fonts
mkdir -p ~/.local/share/fonts

cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -rf CascadiaMono.zip CascadiaFont

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip
unzip CascadiaCode.zip -d CascadiaCode
cp CascadiaCode/*.ttf ~/.local/share/fonts
rm -rf CascadiaCode.zip CascadiaCode

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip
unzip Meslo.zip -d Meslo
cp Meslo/*.ttf ~/.local/share/fonts
rm -rf Meslo.zip Meslo

fc-cache
cd -

# Install Neovim and Lazyvim
sudo dnf install neovim python3-neovim -y

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
cp configs/nvim ~/.config/nvim

# Install Google Chrome
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y
xdg-settings set default-web-browser google-chrome.desktop

# config alacritty
sudo dnf install alacritty -y
mkdir -p ~/.config/alacritty
cp configs/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

# install and configure zellij

cd /tmp
wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
tar -xf zellij.tar.gz zellij
sudo install zellij /usr/local/bin
rm zellij.tar.gz zellij
cd -

mkdir -p ~/.config/zellij
cp configs/zellij/config.kdl ~/.config/zellij/config.kdl

# Install Mise
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >>~/.zshrc

# *****  GNOME EXTENSIONS AND SETUP ***** #

# Ensure computer doesn't go to sleep or lock while installing
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

sudo dnf install gnome-sushi -y
sudo dnf install gnome-tweaks -y
sudo dnf install gnome-shell-extension-tool -y
sudo dnf install gnome-extensions-app -y
sudo dnf install pipx -y
pipx install gnome-extensions-cli --system-site-packages

# Center new windows in the middle of the screen
gsettings set org.gnome.mutter center-new-windows true

# Set Cascadia Mono as the default monospace font
gsettings set org.gnome.desktop.interface font-name 'CaskaydiaMono Nerd Font 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaMono Nerd Font 10'

# Set Dark Mode as default
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set Wallpaper
cp configs/wallpapers/atacama.jpeg ~/Imagens/atacama.jpeg
gsettings set org.gnome.desktop.background picture-uri ~/Imagens/atacama.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark ~/Imagens/atacama.jpeg

# Install Extensions
gext install tactile@lundal.io
gext install just-perfection-desktop@just-perfection
gext install blur-my-shell@aunetx
gext install space-bar@luchrioh
gext install undecorate@sun.wxg@gmail.com
gext install tophat@fflewddur.github.io
gext install AlphabeticalAppGrid@stuarthayhurst
gext install focus-changer@heartmire

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Tactile
gsettings set org.gnome.shell.extensions.tactile border-size 6
gsettings set org.gnome.shell.extensions.tactile gap-size 8
gsettings set org.gnome.shell.extensions.tactile grid-cols 4
gsettings set org.gnome.shell.extensions.tactile grid-rows 3

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure Blur My Shell
# gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
# gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
# gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
# gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
# gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
# gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
# gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
# gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
# gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
# gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
# gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
# gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false
gsettings set org.gnome.shell.extensions.tophat show-cpu true
gsettings set org.gnome.shell.extensions.tophat show-disk true
gsettings set org.gnome.shell.extensions.tophat show-mem true
gsettings set org.gnome.shell.extensions.tophat meter-fg-color "#924d8b"

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

# Use 6 fixed workspaces instead of dynamic mode
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

# Use alt for pinned apps
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

# Use super for workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

# Disable hide-window shortcut (replaced by focus-changer)
gsettings set org.gnome.desktop.wm.keybindings minimize "[]"

# Reserve slots for custom keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

# Start a new alacritty window (rather than just switch to the already open one)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'alacritty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Shift><Alt>2'

# Start a new Chrome window (rather than just switch to the already open one)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'new chrome'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'google-chrome'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Shift><Alt>1'

# Revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300
