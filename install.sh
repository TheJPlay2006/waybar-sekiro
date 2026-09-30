#!/usr/bin/env bash

# ==============================================================================
#  SEKIRO: SHADOWS DIE TWICE - WAYBAR THEME INSTALLER
#  Cross-Distro & Multi-Compositor (Hyprland, Niri, Sway, River)
# ==============================================================================

set -e

RED="\033[0;31m"
BOLD_RED="\033[1;31m"
GOLD="\033[0;33m"
BOLD_GOLD="\033[1;33m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"

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
     SHADOWS DIE TWICE - WAYBAR THEME     
EOF
    echo -e "${GOLD}   「迷えば、敗れる」 - Hesitation is defeat${RESET}\n"
}

check_dependencies() {
    echo -e "${CYAN}[*] Checking dependencies...${RESET}"

    if ! command -v waybar >/dev/null 2>&1; then
        echo -e "${RED}[!] Waybar is not installed.${RESET}"
        echo -e "    Please install it using your package manager:"
        echo -e "    - Arch/CachyOS: ${GOLD}sudo pacman -S waybar${RESET}"
        echo -e "    - Debian/Ubuntu: ${GOLD}sudo apt install waybar${RESET}"
        echo -e "    - Fedora: ${GOLD}sudo dnf install waybar${RESET}"
        echo -e "    - openSUSE: ${GOLD}sudo zypper install waybar${RESET}"
        read -rp "Do you want to continue anyway? [y/N]: " continue_anyway
        if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}[✓] Waybar detected.${RESET}"
    fi

    # Font recommendations check
    if ! fc-list : family 2>/dev/null | grep -iE "nerd|cjk|japanese" >/dev/null 2>&1; then
        echo -e "${GOLD}[i] Tip: For authentic Japanese Kanjis and icons, install:${RESET}"
        echo -e "    - Noto Sans CJK JP (or any Japanese CJK font)"
        echo -e "    - Any Nerd Font (e.g. JetBrainsMono Nerd Font)"
    fi
}

choose_theme() {
    echo -e "\n${BOLD_GOLD}Select a Theme Variant:${RESET}"
    echo -e "  ${BOLD_RED}1)${RESET} Sekiro Kanji   - Flagship theme with Japanese Kanji workspaces (一, 二, 三...) & Blood-red embers"
    echo -e "  ${BOLD_RED}2)${RESET} Sekiro Minimal - Clean, edge-to-edge sleek bar with discreet crimson line"
    echo ""
    read -rp "Enter choice [1-2] (Default: 1): " choice

    case "$choice" in
        2)
            THEME_NAME="sekiro-minimal"
            ;;
        *)
            THEME_NAME="sekiro-kanji"
            ;;
    esac
    echo -e "${GREEN}[✓] Selected: ${THEME_NAME}${RESET}"
}

backup_existing() {
    if [ -d "$WAYBAR_CONFIG_DIR" ] && [ "$(ls -A "$WAYBAR_CONFIG_DIR" 2>/dev/null)" ]; then
        BACKUP_DIR="${HOME}/.config/waybar.bak.$(date +%Y%m%d_%H%M%S)"
        echo -e "\n${CYAN}[*] Creating backup of existing Waybar config at:${RESET}"
        echo -e "    ${GOLD}${BACKUP_DIR}${RESET}"
        mkdir -p "$BACKUP_DIR"
        cp -r "$WAYBAR_CONFIG_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
    fi
}

install_theme() {
    echo -e "\n${CYAN}[*] Installing ${THEME_NAME}...${RESET}"
    mkdir -p "$WAYBAR_CONFIG_DIR/scripts"

    # Copy theme files
    cp -f "$SCRIPT_DIR/themes/$THEME_NAME/config.jsonc" "$WAYBAR_CONFIG_DIR/config.jsonc"
    ln -sf "$WAYBAR_CONFIG_DIR/config.jsonc" "$WAYBAR_CONFIG_DIR/config"
    cp -f "$SCRIPT_DIR/themes/$THEME_NAME/style.css" "$WAYBAR_CONFIG_DIR/style.css"

    # Copy helper scripts
    cp -f "$SCRIPT_DIR/scripts/"*.sh "$WAYBAR_CONFIG_DIR/scripts/"
    chmod +x "$WAYBAR_CONFIG_DIR/scripts/"*.sh

    echo -e "${GREEN}[✓] Theme installed into ${WAYBAR_CONFIG_DIR}${RESET}"
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
    choose_theme
    backup_existing
    install_theme

    read -rp "Do you want to launch/restart Waybar now? [Y/n]: " launch_choice
    if [[ ! "$launch_choice" =~ ^[Nn]$ ]]; then
        restart_waybar
    fi

    echo -e "\n${BOLD_GOLD}======================================================${RESET}"
    echo -e "${BOLD_RED}  Installation Complete! 隻狼 (Sekiro) is ready.${RESET}"
    echo -e "${BOLD_GOLD}======================================================${RESET}\n"
}

main
