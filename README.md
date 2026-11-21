# ubun2204jammy
Automated post-install bootstrap script for Ubuntu 22.04 (Jammy) that installs core GNOME tools, official upstream builds of Firefox, VS Code, and Oracle VirtualBox (+ Extension Pack), plus Node.js LTS and AI CLIs.

# Ubuntu 22.04 (Jammy) Post-Install Setup

An automated bootstrap script (`setup.sh`) for fresh Ubuntu 22.04 installations. It avoids outdated default repository packages and Snap stubs by pulling software directly from official upstream vendor repositories.

## What Gets Installed

* **Core Desktop Utilities (Ubuntu APT):** `git`, `gnome-calculator`, `gnome-disk-utility`, `usb-creator-gtk`, `gnome-terminal`
* **Virtualization (Oracle Official APT):** Latest Oracle VirtualBox 7.x + matching VirtualBox Extension Pack (with unattended PUEL license acceptance and `vboxusers` group setup)
* **Web Browser (Mozilla Official APT):** Native `.deb` Firefox build (replaces the default Jammy Snap stub)
* **Code Editor (Microsoft Official APT):** Visual Studio Code (`code`)
* **Text Editor (Flathub):** `gnome-text-editor` (via Flatpak, since it is absent from Jammy's APT repos)
* **Runtime & AI CLIs (NodeSource + npm):** Node.js LTS, `@anthropic-ai/claude-code` (`claude`), and `@openai/codex` (`codex`)

## Quick Start

Clone the repository and run the setup script:

```bash
git clone https://github.com
cd jammy-setup
./setup.sh
```

> **Note:** Log out and back in after the script finishes so your user account's new `vboxusers` group permissions take effect for VirtualBox USB passthrough.
