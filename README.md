# Ubuntu 22.04 (Jammy) Post-Install Setup

An automated bootstrap script (`setup.sh`) for fresh Ubuntu 22.04 installations, pulling apps from official upstream repositories, PPAs, and Flathub while skipping default Snap stubs.

## Summary of Installed Components

* **Desktop & Core:** GNOME Desktop (`ubuntu-desktop-minimal`), Snap Store, GNOME Software, and essential utilities (`git`, `gnome-calculator`, `gnome-disk-utility`, `usb-creator-gtk`, `gnome-terminal`).
* **Virtualization:** Oracle VirtualBox 7.x and Extension Pack via official Oracle APT.
* **Browsers & Editors:** Native `.deb` Firefox (Mozilla APT), Brave Browser (Brave APT), Visual Studio Code (Microsoft APT), and GNOME Text Editor (Flathub).
* **Media & Tools:** OBS Studio (official PPA), Audacity (Flathub), VLC Media Player (APT), Node.js LTS, Claude Code CLI, and OpenAI Codex CLI.

## Quick Start

Run this command on a fresh Ubuntu 22.04 install:

```bash
sudo apt-get update && sudo apt-get install -y git && git clone https://github.com && cd ubun2204jammy && ./setup.sh
```

Reboot afterward to apply desktop and group settings:
```bash
sudo reboot
```
