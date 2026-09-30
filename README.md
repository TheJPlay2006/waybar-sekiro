# ⚔️ Sekiro: Shadows Die Twice — Waybar Theme (隻狼)

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-crimson.svg?style=for-the-badge)](LICENSE)
[![Waybar](https://img.shields.io/badge/Waybar-v0.9.0%2B-181113.svg?style=for-the-badge&logo=wayland&logoColor=white)](https://github.com/Alexays/Waybar)
[![Compositors](https://img.shields.io/badge/Compositors-Hyprland%20%7C%20Niri%20%7C%20Sway%20%7C%20River-b14046.svg?style=for-the-badge)](https://github.com)
[![Platform](https://img.shields.io/badge/Platform-Arch%20%7C%20Fedora%20%7C%20Debian%20%7C%20openSUSE-e63946.svg?style=for-the-badge&logo=linux&logoColor=white)](https://kernel.org)

<p align="center">
  <b>「迷えば、敗れる」 — <i>Hesitation is defeat</i></b><br>
  An atmospheric, dark-feudal, calligraphy-inspired Waybar theme capturing the essence of FromSoftware's <i>Sekiro: Shadows Die Twice</i>.
</p>

</div>

---

## 🗡️ Features

* **⛩️ Traditional Japanese Kanji Workspaces:**  
  Workspaces numbered with authentic kanjis (`一`, `二`, `三`, `四`, `五`, `六`, `七`, `八`, `九`, `十`).
* **🩸 Deathblow & Danger Accents:**  
  - Active workspace glows in radiant vermilion blood-red with the Deathblow kanji (`斬`).
  - Urgent and alert workspaces pulse with the iconic Sekiro danger kanji (`危`).
* **🔴 Resurrection Nodes (`回生`):**  
  Battery levels and status rendered as Shinobi resurrection orbs.
* **⚔️ Vitality & Posture Gauges:**  
  Volume, CPU, and RAM modules themed after Ashina vitality and posture meters.
* **🌐 Cross-Compositor Native:**  
  Built with native support for **Hyprland**, **Niri**, **Sway**, **River**, and generic `wlroots` window managers.
* **🐧 Distro-Agnostic:**  
  Tested and compatible with Arch Linux / CachyOS, Fedora, Ubuntu/Debian, openSUSE, and more.
* **🎨 Two Distinct Presets:**  
  1. `sekiro-kanji`: The flagship theme with kanji numerals, aged gold borders, and glowing blood embers.
  2. `sekiro-minimal`: A slim, edge-to-edge minimalist design with a clean crimson line accent.

---

## 🎨 Color Palette

| Color Name | Hex / RGB | Role |
|---|---|---|
| **Kurogane (Dark Iron / Ash)** | `#161113` | Module backgrounds and capsules |
| **Kurenai (Blood Vermilion)** | `#e63946` | Primary deathblow accent & active borders |
| **Homura (Resurrection Flame)** | `#ff4d5a` | Glowing highlights & hover states |
| **Kin (Aged Temple Gold)** | `#d4af37` | Secondary text & refined borders |
| **Washi (Parchment Bone)** | `#f5f0ea` | Primary text and icons |

---

## 📦 Prerequisites & Recommended Fonts

To render the Japanese kanjis and Shinobi icons properly, install:

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

## 🚀 Quick Installation

Clone the repository and run the automated interactive installer:

```bash
git clone https://github.com/TheJPlay2006/waybar-sekiro.git
cd waybar-sekiro
chmod +x install.sh
./install.sh
```

### What the installer does:
1. Verifies that Waybar is installed and checks for font availability.
2. Lets you choose between **Sekiro Kanji** (Flagship) and **Sekiro Minimal**.
3. Creates a safe automatic backup of any existing Waybar configuration to `~/.config/waybar.bak.<timestamp>`.
4. Installs configuration, stylesheet, and helper scripts into `~/.config/waybar`.
5. Restarts Waybar cleanly.

---

## 📂 Project Structure

```text
waybar-sekiro/
├── install.sh                  # Interactive cross-distro installer
├── uninstall.sh                # Safe uninstaller (with backup restore)
├── LICENSE                     # MIT License
├── README.md                   # Documentation
├── scripts/
│   ├── mediaplayer.sh          # Lightweight MPRIS player reader
│   └── updates.sh              # Multi-distro package update counter
└── themes/
    ├── sekiro-kanji/           # Flagship Kanji & Resurrection theme
    │   ├── config.jsonc
    │   └── style.css
    └── sekiro-minimal/         # Minimalist edge-to-edge edition
        ├── config.jsonc
        └── style.css
```

---

## 🛠️ Customization

Colors are defined at the top of `style.css` using CSS `@define-color` variables for easy personal tuning:

```css
@define-color bg_module rgba(22, 17, 19, 0.88);
@define-color border_gold rgba(198, 159, 104, 0.35);
@define-color sekiro_red #e63946;
@define-color sekiro_flame #ff4d5a;
```

After modifying `~/.config/waybar/style.css`, reload Waybar instantly with:

```bash
pkill -SIGUSR2 waybar
```

---

## 🔄 Uninstallation

To remove the theme and restore your previous configuration:

```bash
cd waybar-sekiro
./uninstall.sh
```

---

## 📜 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more details.

---

<div align="center">
  <sub>Created with honor by <a href="https://github.com/TheJPlay2006">Jairo Herrera Romero (TheJPlay2006)</a> • Inspired by FromSoftware's masterpiece.</sub>
</div>