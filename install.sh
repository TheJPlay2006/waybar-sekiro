#!/usr/bin/env bash

# ==============================================================================
#  SEKIRO: SHADOWS DIE TWICE — COMPLETE LINUX SUITE INSTALLER
#  Waybar Theme • GRUB Theme • Fastfetch • Wallpapers
#  Multi-Distro (Arch, Debian, Ubuntu, Fedora, openSUSE)
#  Multi-Compositor (Hyprland, Niri, Sway, River)
# ==============================================================================

set -e

RED="\033[0;31m"
BOLD_RED="\033[1;31m"
GOLD="\033[0;33m"
BOLD_GOLD="\033[1;33m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
FASTFETCH_CONFIG_DIR="$HOME/.config/fastfetch"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/Sekiro"

print_banner() {
    clear
    echo -e "${BOLD_RED}"
    cat << "EOF"
   _____ ______ _  _______ _____   ____  
  / ____|  ____| |/ /_   _|  __ \ / __ \ 
 | (___ | |__  | ' /  | | | |__) | |  | |
  \___ \|  __| |  <   | | |  _  /| |  | |
  ____) | |____| . \ _| |_| | \ \| |__| |
 |_____/|______|_|\_\_____|_|  \_\\____/ 
       SHADOWS DIE TWICE — LINUX SUITE   
EOF
    echo -e "${BOLD_GOLD}   「迷えば、敗れる」 — Hesitation is defeat${RESET}"
    echo -e "${MAGENTA}   🌸 桜 (Sakura) • ⚔ 刀 (Katana) • 🩸 回生 (Resurrection)${RESET}\n"
}

check_dependencies() {
    echo -e "${CYAN}[*] Checking system environment...${RESET}"

    if command -v waybar >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] Waybar is installed.${RESET}"
    else
        echo -e "${GOLD}[!] Waybar not found. Please install it with your package manager:${RESET}"
        echo -e "    - Arch/CachyOS: sudo pacman -S waybar"
        echo -e "    - Debian/Ubuntu: sudo apt install waybar"
        echo -e "    - Fedora: sudo dnf install waybar"
    fi

    # Font recommendations check
    if ! fc-list : family 2>/dev/null | grep -iE "cjk|noto.*jp" >/dev/null 2>&1; then
        echo -e "${GOLD}[i] Recommended for Japanese Kanji (一, 二, 三, 斬, 危):${RESET}"
        echo -e "    - Arch: sudo pacman -S noto-fonts-cjk"
        echo -e "    - Debian/Ubuntu: sudo apt install fonts-noto-cjk"
        echo -e "    - Fedora: sudo dnf install google-noto-sans-cjk-fonts"
    else
        echo -e "${GREEN}[✓] Japanese CJK Font detected.${RESET}"
    fi
}

install_waybar() {
    echo -e "\n${BOLD_GOLD}Select Waybar Style:${RESET}"
    echo -e "  ${BOLD_RED}1)${RESET} Sekiro Kanji & Sakura (Flagship — Traditional Kanjis, Vitality/Posture meters, Embers)"
    echo -e "  ${BOLD_RED}2)${RESET} Sekiro Minimal (Sleek edge-to-edge line with crimson accents)"
    read -rp "Choice [1-2] (Default: 1): " wb_choice

    case "$wb_choice" in
        2) THEME_VARIANT="sekiro-minimal" ;;
        *) THEME_VARIANT="sekiro-kanji" ;;
    esac

    # Backup existing
    if [ -d "$WAYBAR_CONFIG_DIR" ] && [ "$(ls -A "$WAYBAR_CONFIG_DIR" 2>/dev/null)" ]; then
        BACKUP_DIR="${HOME}/.config/waybar.bak.$(date +%Y%m%d_%H%M%S)"
        echo -e "${CYAN}[*] Backing up existing Waybar config to ${GOLD}${BACKUP_DIR}${RESET}"
        mkdir -p "$BACKUP_DIR"
        cp -r "$WAYBAR_CONFIG_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
    fi

    mkdir -p "$WAYBAR_CONFIG_DIR/scripts"

    # Install selected theme
    cp -f "$SCRIPT_DIR/themes/$THEME_VARIANT/config.jsonc" "$WAYBAR_CONFIG_DIR/config.jsonc"
    ln -sf "$WAYBAR_CONFIG_DIR/config.jsonc" "$WAYBAR_CONFIG_DIR/config"
    cp -f "$SCRIPT_DIR/themes/$THEME_VARIANT/style.css" "$WAYBAR_CONFIG_DIR/style.css"

    # Copy scripts
    cp -f "$SCRIPT_DIR/scripts/"*.sh "$WAYBAR_CONFIG_DIR/scripts/"
    chmod +x "$WAYBAR_CONFIG_DIR/scripts/"*.sh

    echo -e "${GREEN}[✓] Waybar theme ($THEME_VARIANT) installed successfully!${RESET}"
}

install_wallpapers() {
    echo -e "\n${CYAN}[*] Installing Sekiro Wallpapers...${RESET}"
    mkdir -p "$WALLPAPERS_DIR"
    cp -f "$SCRIPT_DIR/wallpapers/"* "$WALLPAPERS_DIR/" 2>/dev/null || true
    echo -e "${GREEN}[✓] Wallpapers installed to: ${GOLD}${WALLPAPERS_DIR}${RESET}"

    # If noctalia or swww or hyprpaper is running, offer to apply
    if command -v noctalia >/dev/null 2>&1; then
        echo -e "${CYAN}[*] Setting Sekiro wallpaper via Noctalia...${RESET}"
        noctalia msg wallpaper-set "$WALLPAPERS_DIR/sekiro_ashina_1080p.png" 2>/dev/null || true
    fi
}

install_fastfetch() {
    echo -e "\n${CYAN}[*] Installing Sekiro Fastfetch configuration...${RESET}"
    mkdir -p "$FASTFETCH_CONFIG_DIR"
    cp -f "$SCRIPT_DIR/fastfetch/config.jsonc" "$FASTFETCH_CONFIG_DIR/config.jsonc"
    echo -e "${GREEN}[✓] Fastfetch config installed! Run 'fastfetch' in your terminal.${RESET}"
}

install_grub() {
    echo -e "\n${CYAN}[*] Installing Sekiro GRUB Theme...${RESET}"
    echo -e "${GOLD}[i] This requires root privileges (sudo).${RESET}"

    THEME_DIR="/boot/grub/themes"
    THEME_NAME="Sekiro"

    sudo mkdir -p "${THEME_DIR}/${THEME_NAME}"
    sudo cp -rf "$SCRIPT_DIR/grub/"* "${THEME_DIR}/${THEME_NAME}/"
    sudo chmod -R 755 "${THEME_DIR}/${THEME_NAME}"

    # Generate fonts if grub-mkfont is available
    if command -v grub-mkfont >/dev/null 2>&1; then
        echo -e "${CYAN}[*] Compiling GRUB fonts...${RESET}"
        sudo grub-mkfont -s 16 -o "${THEME_DIR}/${THEME_NAME}/dersu_uzala_brush_16.pf2" "${THEME_DIR}/${THEME_NAME}/Dersu Uzala brush.ttf" 2>/dev/null || true
        sudo grub-mkfont -s 54 -o "${THEME_DIR}/${THEME_NAME}/dersu_uzala_brush_54.pf2" "${THEME_DIR}/${THEME_NAME}/Dersu Uzala brush.ttf" 2>/dev/null || true
        sudo grub-mkfont -s 60 -o "${THEME_DIR}/${THEME_NAME}/dersu_uzala_brush_60.pf2" "${THEME_DIR}/${THEME_NAME}/Dersu Uzala brush.ttf" 2>/dev/null || true
    fi

    # Update /etc/default/grub
    sudo sed -i '/GRUB_THEME=/d' /etc/default/grub
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" | sudo tee -a /etc/default/grub >/dev/null
    
    # Update GRUB config
    echo -e "${CYAN}[*] Updating GRUB config...${RESET}"
    if command -v update-grub >/dev/null 2>&1; then
        sudo update-grub
    elif command -v grub-mkconfig >/dev/null 2>&1; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    elif command -v grub2-mkconfig >/dev/null 2>&1; then
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    fi

    echo -e "${GREEN}[✓] Sekiro GRUB Theme installed successfully!${RESET}"
}

restart_waybar() {
    echo -e "\n${CYAN}[*] Restarting Waybar...${RESET}"
    pkill -x waybar 2>/dev/null || true
    sleep 0.5

    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch exec waybar >/dev/null 2>&1 &
    elif command -v niri >/dev/null 2>&1 && [ -n "$WAYLAND_DISPLAY" ]; then
        niri msg action spawn -- waybar >/dev/null 2>&1 || nohup waybar >/dev/null 2>&1 &
    else
        nohup waybar >/dev/null 2>&1 &
    fi
    echo -e "${GREEN}[✓] Waybar is running!${RESET}"
}

main() {
    print_banner
    check_dependencies

    echo -e "\n${BOLD_GOLD}What would you like to install?${RESET}"
    echo -e "  ${BOLD_RED}1)${RESET} Complete Sekiro Suite (Waybar + Wallpapers + Fastfetch + GRUB Theme)"
    echo -e "  ${BOLD_RED}2)${RESET} Waybar Theme Only"
    echo -e "  ${BOLD_RED}3)${RESET} GRUB Theme Only"
    echo -e "  ${BOLD_RED}4)${RESET} Wallpapers & Terminal Fastfetch Only"
    echo ""
    read -rp "Enter choice [1-4] (Default: 1): " install_mode

    case "$install_mode" in
        2)
            install_waybar
            read -rp "Launch Waybar now? [Y/n]: " start_wb
            [[ ! "$start_wb" =~ ^[Nn]$ ]] && restart_waybar
            ;;
        3)
            install_grub
            ;;
        4)
            install_wallpapers
            install_fastfetch
            ;;
        *)
            install_waybar
            install_wallpapers
            install_fastfetch
            read -rp "Do you want to install the Sekiro GRUB Bootloader theme as well? [Y/n]: " grub_confirm
            [[ ! "$grub_confirm" =~ ^[Nn]$ ]] && install_grub

            read -rp "Launch Waybar now? [Y/n]: " start_wb
            [[ ! "$start_wb" =~ ^[Nn]$ ]] && restart_waybar
            ;;
    esac

    echo -e "\n${BOLD_GOLD}======================================================${RESET}"
    echo -e "${BOLD_RED}  隻狼 (Sekiro): Installation Complete!${RESET}"
    echo -e "${BOLD_GOLD}  「迷えば、敗れる」 — Hesitation is defeat${RESET}"
    echo -e "${BOLD_GOLD}======================================================${RESET}\n"
}

main
