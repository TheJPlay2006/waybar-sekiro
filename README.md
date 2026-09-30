# ⚔️ Sekiro: Shadows Die Twice — Linux Theme Suite (隻狼)

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-crimson.svg?style=for-the-badge)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%99%A5-success.svg?style=for-the-badge)](LICENSE)
[![Author: Jairo Herrera Romero](https://img.shields.io/badge/Author-Jairo%20Herrera%20Romero-d4af37.svg?style=for-the-badge&logo=github)](https://github.com/TheJPlay2006)
[![Waybar](https://img.shields.io/badge/Waybar-v0.9.0%2B-181113.svg?style=for-the-badge&logo=wayland&logoColor=white)](https://github.com/Alexays/Waybar)
[![Dashboard](https://img.shields.io/badge/Dashboard-Shinobi%20Sanctuary-crimson.svg?style=for-the-badge)](dashboard/)
[![GRUB Theme](https://img.shields.io/badge/GRUB-1080p%20%7C%201440p-b14046.svg?style=for-the-badge)](grub/)
[![Fastfetch](https://img.shields.io/badge/Terminal-Fastfetch%20Themed-d4af37.svg?style=for-the-badge)](fastfetch/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](https://github.com/TheJPlay2006/waybar-sekiro/pulls)

<p align="center">
  <b>「迷えば、敗れる」 — <i>Hesitation is defeat</i></b><br>
  A complete, atmospheric Linux desktop suite inspired by FromSoftware's masterpiece <b>Sekiro: Shadows Die Twice</b>.<br>
  Featuring an authentic Waybar theme, full Shinobi Sanctuary Dashboard (animated falling Sakura petals), GRUB bootloader theme, custom terminal Fastfetch, and high-res wallpapers.
</p>

</div>

---

## 🗡️ What's Inside the Suite

```text
waybar-sekiro/
├── 📜 install.sh               # Universal installer for all suite components
├── 🔄 uninstall.sh             # Safe uninstaller (with automatic backup restoration)
├── ⚖️ LICENSE                  # MIT License (100% Free & Open Source)
├── 👥 CONTRIBUTORS.md          # Project authors and contribution guide
├── 📂 dashboard/               # Standalone Shinobi Sanctuary Dashboard (Falling Sakura Petals)
├── 📂 themes/
│   ├── sekiro-kanji/           # Flagship Waybar theme (Kanji, Sakura, Vitality & Posture)
│   └── sekiro-minimal/         # Minimalist edge-to-edge crimson line edition
├── 📂 grub/                    # Full Sekiro GRUB Bootloader theme (1080p/1440p + Brush fonts)
├── 📂 fastfetch/               # Custom Terminal Fetch (Clan, Dojo, Vitality & Posture stats)
├── 📂 wallpapers/              # High-resolution Sekiro wallpapers & shinobi avatar
└── 📂 scripts/                 # MPRIS media reader and cross-distro update counter
```

---

## 🌐 Universal Multi-Distribution & Compositor Support

Sekiro Linux Suite is engineered from the ground up to be **100% Free & Open Source (FOSS)**, universally compatible across major Linux distributions, architectures, and modern Wayland compositors:

### Linux Distributions
| Distribution / Flavor | Status | Package Manager | Tested / Supported |
| :--- | :---: | :---: | :--- |
| **Arch Linux / CachyOS / Manjaro / EndeavourOS** | 🟢 | `pacman` | Fully Supported & Automated |
| **Fedora / RHEL / Nobara** | 🟢 | `dnf` | Fully Supported & Automated |
| **Debian / Ubuntu / Pop!_OS / Linux Mint** | 🟢 | `apt` | Fully Supported & Automated |
| **openSUSE (Tumbleweed / Leap)** | 🟢 | `zypper` | Fully Supported & Automated |
| **Void Linux / NixOS / Gentoo** | 🟢 | Distro Native | Fully Supported |

### Wayland Compositors
| Compositor | Workspace Module | Status | Notes |
| :--- | :--- | :---: | :--- |
| **Niri** | `niri/workspaces` | 🟢 Verified | Native dynamic workspace support with Kanji numerals |
| **Hyprland** | `hyprland/workspaces` | 🟢 Verified | Full special workspace & active monitor support |
| **Sway** | `sway/workspaces` | 🟢 Verified | Classic i3/Sway workspace mapping |
| **River** | `river/tags` | 🟢 Verified | River tag switching support |
| **Wayfire / Labwc** | `wlr/workspaces` | 🟢 Verified | wlroots ext-workspace support |

---

## 🌸 1. The Waybar Experience

* **⛩️ Torii & Sakura Launcher:**  
  Leftmost emblem featuring the sacred Torii gate and falling cherry blossom petals (`⛩ 隻狼 🌸`).
* **🪨 Traditional Japanese Kanji Workspaces:**  
  Workspaces rendered as stamped Japanese kanjis:  
  `一` (1), `二` (2), `三` (3), `四` (4), `五` (5), `六` (6), `七` (7), `八` (8), `九` (9), `十` (10).
* **🩸 Deathblow Slash (`斬`):**  
  The active workspace bursts into a radiant vermilion-blood gradient with a deathblow slash effect.
* **⚠️ Danger Alert (`危`):**  
  Urgent or alerting workspaces pulse in vibrant crimson red.
* **⚔️ Katana Window Titles:**  
  Active windows enclosed in traditional calligraphy brackets: `⚔ 『 Active Window 』`.
* **🔴 Resurrection Nodes (`回生`):**  
  Battery levels and status rendered as Shinobi resurrection orbs.
* **📊 Vitality & Posture Gauges:**  
  - **Vitality (CPU):** Turquoise meter (`#2ec4b6`)
  - **Posture (Volume):** Burning amber meter (`#ff9f1c`)
  - **Spirit Emblems (RAM):** Temple gold meter (`#d4af37`)
  - **Spirit Network (Wi-Fi):** Azure connection meter (`#4cc9f0`)
* **鐘 Sanctuary Bell Clock:**  
  Japanese time formatting with rich tooltips including calendar and Sekiro quotes.

---

## 🌸 2. Shinobi Sanctuary Dashboard (Control Center)

A **100% custom, standalone Wayland Control Center** built specifically for the Sekiro Linux Suite — zero external desktop shells required!

* **🌸 Real-Time Falling Sakura Petals & Embers:**  
  Interactive HTML5 Canvas particle system with delicate cherry blossom petals and glowing sparks drifting across the panel.
* **⚔️ Combat HUD Gauges:**  
  - **Vitality Bar (体力):** Glowing turquoise health meter displaying real-time CPU utilization.
  - **Posture Bar (姿勢):** Amber/gold posture meter that fills up with RAM consumption.
* **⛩️ Prosthetic Tools & Quick Actions:**  
  - **Wi-Fi Toggle:** Instant connect/disconnect with active SSID display.
  - **Bluetooth Toggle:** Controller/audio connectivity.
  - **Shinobi Terminal:** Quick spawn Alacritty.
  - **App Launcher:** Integrated Torii application search.
* **🎚️ Katana Sliders:**  
  Live volume adjustment (PipeWire/WirePlumber) and screen brightness slider.
* **🎵 Ancient Melodies Music Shrine:**  
  MPRIS media player with rotating Sakura blossom disc and playback controls (`⏮`, `▶ / ⏸`, `⏭`).
* **🏮 Sculptor's Idol Session Controls:**  
  - `瞑想 (Lock)` • `離脱 (Logout)` • `再起 (Reboot)` • `切腹 (Shutdown)`
* **⚡ Seamless Waybar Integration & Toggle:**  
  Click any module on Waybar or press `Mod+S` (or `ESC` to close).

---

## 🏮 3. The GRUB Bootloader Theme

Included in `grub/`, featuring:
* Custom calligraphy brush typography (`Dersu Uzala brush` & `Fira Code`).
* Native **1920x1080** and **2560x1440** resolution support.
* Dynamic timeout countdown: `Hesitation is defeat: %ds`.
* Automatic font compilation and bootloader regeneration via the installer.

---

## 📜 3. Custom Fastfetch Terminal

Included in `fastfetch/`:
* Displays system information themed after the Shinobi journey:
  - **Clan:** OS Name
  - **Discipline:** Linux Kernel
  - **Dojo:** Window Manager / Compositor
  - **Scroll:** Terminal Emulator
  - **Vitality:** CPU Usage & Model
  - **Posture:** RAM Utilization
  - **Journey:** System Uptime

---

## 📦 Prerequisites & Recommended Fonts

For authentic Japanese calligraphy and icons, install:

### 1. Japanese CJK Font (Recommended: `Noto Sans CJK JP`)
* **Arch Linux / CachyOS:**
  ```bash
  sudo pacman -S noto-fonts-cjk
  ```
* **Debian / Ubuntu:**
  ```bash
  sudo apt install fonts-noto-cjk
  ```
* **Fedora:**
  ```bash
  sudo dnf install google-noto-sans-cjk-fonts
  ```

### 2. Nerd Font (e.g. `JetBrainsMono Nerd Font` or `Meslo Nerd Font`)
* **Arch Linux / CachyOS:**
  ```bash
  sudo pacman -S ttf-jetbrains-mono-nerd
  ```
* **Other distros:** Download from [Nerd Fonts releases](https://www.nerdfonts.com/).

### 3. Media Controls (Optional)
* For media playback control via Waybar:
  ```bash
  sudo pacman -S playerctl   # Arch
  sudo apt install playerctl # Debian/Ubuntu
  sudo dnf install playerctl # Fedora
  ```

---

## 🚀 Installation

Clone the repository and run the automated interactive installer:

```bash
git clone https://github.com/TheJPlay2006/waybar-sekiro.git
cd waybar-sekiro
chmod +x install.sh
./install.sh
```

### Interactive Installer Menu:
```text
What would you like to install?
  1) Complete Sekiro Suite (Waybar + Wallpapers + Fastfetch + GRUB Theme)
  2) Waybar Theme Only
  3) GRUB Theme Only
  4) Wallpapers & Terminal Fastfetch Only
```

The installer automatically:
1. Backs up any existing configuration.
2. Detects your window manager (Niri, Hyprland, Sway, River).
3. Compiles the custom fonts and updates the bootloader if GRUB is chosen.
4. Restarts Waybar smoothly.

---

## 🛠️ Customization

Colors are defined at the top of `style.css` using CSS `@define-color` variables for easy personal tuning:

```css
@define-color bg_module rgba(22, 17, 19, 0.90);
@define-color border_gold rgba(212, 175, 55, 0.42);
@define-color sekiro_red #e63946;
@define-color sekiro_flame #ff4d5a;
@define-color vitality_teal #2ec4b6;
@define-color posture_amber #ff9f1c;
```

Reload Waybar instantly with:

```bash
pkill -SIGUSR2 waybar
```

---

## 🔄 Uninstallation

To remove any installed component and restore your previous backup:

```bash
cd waybar-sekiro
./uninstall.sh
```

---

## 👥 Author & Contributors

This project is created and maintained with honor by:

* **Jairo Herrera Romero** ([@TheJPlay2006](https://github.com/TheJPlay2006)) — *Project Founder, Lead Developer & Designer*

We warmly welcome contributions from the Linux community worldwide!  
Check out [`CONTRIBUTORS.md`](CONTRIBUTORS.md) for contribution guidelines, ideas, and details on how to contribute.

---

## 📜 License

Distributed under the **MIT License**. 100% Free and Open Source. See [`LICENSE`](LICENSE) for more details.

---

<div align="center">
  <sub>Created with honor by <a href="https://github.com/TheJPlay2006">Jairo Herrera Romero (TheJPlay2006)</a> • Inspired by FromSoftware's masterpiece.</sub>
</div>