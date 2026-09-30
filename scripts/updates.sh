#!/usr/bin/env bash

# Multi-distro package update counter for Waybar
# Supports: Arch (pacman/checkupdates), Debian/Ubuntu (apt), Fedora (dnf), openSUSE (zypper)

updates=0

if command -v checkupdates >/dev/null 2>&1; then
    # Arch Linux / CachyOS
    updates=$(checkupdates 2>/dev/null | wc -l)
elif command -v apt-get >/dev/null 2>&1; then
    # Debian / Ubuntu
    updates=$(apt-get -s -o Debug::NoLocking=true upgrade 2>/dev/null | grep -c '^Inst')
elif command -v dnf >/dev/null 2>&1; then
    # Fedora / RHEL
    updates=$(dnf check-update -q 2>/dev/null | grep -v '^$' | grep -v 'Last metadata' | wc -l)
elif command -v zypper >/dev/null 2>&1; then
    # openSUSE
    updates=$(zypper list-updates 2>/dev/null | grep -c '^v')
fi

if [ "$updates" -gt 0 ]; then
    printf '{"text":"%s","tooltip":"%s updates available","class":"updates-available"}\n' "$updates" "$updates"
else
    printf '{"text":"","tooltip":"System is up to date","class":"up-to-date"}\n'
fi
