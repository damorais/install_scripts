# Install VSCode from microsoft repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

# dnf check-update
sudo dnf install code -y # or code-insiders

# Install and configure Snapper for simple BTFRS snapshots and btrfs-assistant to provide a gui for snapshots management
sudo dnf install snapper btrfs-assistant -y

sudo snapper -c root create-config /
sudo snapper -c home create-config /home

# Install LaTeX
sudo dnf install texlive-scheme-full -y

# Install Obsidian
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub com.bitwarden.desktop

# Set default terminal to Alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'

# Favorite apps for dock
apps=(
  "google-chrome.desktop"
  "Alacritty.desktop"
  "nvim.desktop"
  "code.desktop"
  "md.obsidian.Obsidian.desktop"
  "com.bitwarden.desktop.desktop"
  "org.gnome.Nautilus.desktop"
  "org.gnome.TextEditor.desktop"
  "org.gnome.Settings.desktop"
)

# Array to hold installed favorite apps
installed_apps=()

# Directory where .desktop files are typically stored
desktop_dirs=(
  "/var/lib/flatpak/exports/bin"
  "/var/lib/flatpak/exports/share/applications"
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

# Check if a .desktop file exists for each app
for app in "${apps[@]}"; do
  for dir in "${desktop_dirs[@]}"; do
    if [ -f "$dir/$app" ]; then
      installed_apps+=("$app")
      break
    fi
  done
done

# Convert the array to a format suitable for gsettings
favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set the favorite apps
gsettings set org.gnome.shell favorite-apps "$favorites_list"
