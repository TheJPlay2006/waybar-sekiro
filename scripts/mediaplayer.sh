#!/usr/bin/env bash

# Multi-player MPRIS reader with Playerctl / D-Bus fallback
if ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    
    if [ -n "$title" ]; then
        if [ "$status" = "Playing" ]; then
            icon=""
        else
            icon=""
        fi
        
        if [ -n "$artist" ]; then
            output="$icon $artist - $title"
        else
            output="$icon $title"
        fi
        
        # Truncate if too long
        if [ ${#output} -gt 35 ]; then
            output="${output:0:32}..."
        fi
        
        printf '{"text":"%s","tooltip":"%s (%s)","class":"%s"}\n' "$output" "$artist - $title" "$status" "$status"
    else
        printf '{"text":"","class":"stopped"}\n'
    fi
else
    printf '{"text":"","class":"stopped"}\n'
fi
