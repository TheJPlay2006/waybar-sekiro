#!/usr/bin/env bash

# ==============================================================================
#  SEKIRO: SHADOWS DIE TWICE - WAYBAR THEME UNINSTALLER
# ==============================================================================

set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
GOLD="\033[0;33m"
RESET="\033[0m"

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"

echo -e "${RED}[*] Uninstalling Sekiro Waybar Theme...${RESET}"

# Find most recent backup if available
LATEST_BACKUP=$(ls -td "$HOME/.config/waybar.bak."* 2>/dev/null | head -n 1)

if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
    echo -e "${CYAN}[i] Found backup at: ${GOLD}${LATEST_BACKUP}${RESET}"
    read -rp "Do you want to restore this backup? [Y/n]: " restore_choice
    if [[ ! "$restore_choice" =~ ^[Nn]$ ]]; then
        rm -rf "$WAYBAR_CONFIG_DIR"
        mkdir -p "$WAYBAR_CONFIG_DIR"
        cp -r "$LATEST_BACKUP"/* "$WAYBAR_CONFIG_DIR/"
        echo -e "${GREEN}[✓] Backup restored successfully!${RESET}"
    else
        rm -rf "$WAYBAR_CONFIG_DIR"
        echo -e "${GREEN}[✓] Waybar config directory removed.${RESET}"
    fi
else
    rm -rf "$WAYBAR_CONFIG_DIR"
    echo -e "${GREEN}[✓] Waybar config directory removed.${RESET}"
fi

pkill -x waybar 2>/dev/null || true
echo -e "${GREEN}[✓] Uninstallation complete.${RESET}"
