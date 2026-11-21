#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "=== 1. Updating base system & installing prerequisites ==="
sudo apt-get update
sudo apt-get install -y software-properties-common curl wget gpg ca-certificates apt-transport-https
sudo add-apt-repository -y universe
sudo apt-get update

echo "=== 2. Installing GNOME Desktop Environment (Minimal) ==="
sudo apt-get install -y ubuntu-desktop-minimal
sudo systemctl set-default graphical.target

echo "=== 3. Installing core Ubuntu desktop & media utilities ==="
sudo apt-get install -y git gnome-calculator gnome-disk-utility usb-creator-gtk gnome-terminal vlc

echo "=== 4. Installing Oracle VirtualBox & Matching Extension Pack ==="
sudo install -d -m 0755 /etc/apt/keyrings
wget -qO- https://virtualbox.org | sudo gpg --yes --dearmor -o /etc/apt/keyrings/oracle-virtualbox-2016.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/oracle-virtualbox-2016.gpg] https://virtualbox.org jammy contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null
sudo apt-get update

LATEST_VBOX=$(apt-cache search '^virtualbox-7\.' | awk '{print $1}' | sort -V | tail -n 1)
sudo apt-get install -y "${LATEST_VBOX:-virtualbox-7.1}"
sudo usermod -aG vboxusers "$USER"

VBOX_VER=$(vboxmanage --version | cut -d'r' -f1)
EXTPACK_FILE="/tmp/Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
EXTPACK_URL="https://virtualbox.org{VBOX_VER}/Oracle_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"
EXTPACK_URL_LEGACY="https://virtualbox.org{VBOX_VER}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VER}.vbox-extpack"

if ! wget -q "$EXTPACK_URL" -O "$EXTPACK_FILE"; then
  wget -q "$EXTPACK_URL_LEGACY" -O "$EXTPACK_FILE"
fi

PUEL_HASH=$(tar -xzf "$EXTPACK_FILE" -O ./ExtPack-license.txt | sha256sum | awk '{print $1}')
sudo vboxmanage extpack install --replace --accept-license="$PUEL_HASH" "$EXTPACK_FILE"
rm -f "$EXTPACK_FILE"

echo "=== 5. Installing Firefox (Official Mozilla APT repo) ==="
sudo snap remove firefox 2>/dev/null || true
wget -q https://mozilla.org -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://mozilla.org mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
echo 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null
sudo apt-get update
sudo apt-get install -y firefox

echo "=== 6. Installing Brave Browser, VS Code, OBS Studio & Audacity ==="
# Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave.com
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave.com stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null

# VS Code
wget -qO- https://microsoft.com | sudo gpg --yes --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://microsoft.com stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# OBS Studio PPA
sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install -y brave-browser code obs-studio

# Audacity via Flatpak
sudo apt-get install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org
sudo flatpak install -y flathub org.gnome.TextEditor org.audacityteam.Audacity

echo "=== 7. Installing Snap Store, Node.js LTS & AI CLIs ==="
sudo apt-get install -y snapd gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap
sudo snap install snap-store
curl -fsSL https://nodesource.com | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g @anthropic-ai/claude-code @openai/codex

echo "=== All installations complete! Reboot your system to load the GNOME desktop and VirtualBox permissions. ==="
