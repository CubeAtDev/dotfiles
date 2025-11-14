#!/usr/bin/env bash

WALL_DIR="$HOME/Images/Wallpapers"
TRACK_FILE="/tmp/hypr_workspace_wallpapers.txt"
LOG_FILE="/tmp/hyprwall.log"

[ ! -f "$TRACK_FILE" ] && touch "$TRACK_FILE"
log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG_FILE"; }

set_workspace_wallpaper() {
    local workspace_id="$1"
    local wallpaper

    # Vérifie si un wallpaper existe déjà pour ce workspace
    wallpaper=$(grep "^$workspace_id," "$TRACK_FILE" | cut -d',' -f2)

    if [ -z "$wallpaper" ]; then
        # Choix aléatoire si pas encore assigné
        wallpaper=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        echo "$workspace_id,$wallpaper" >> "$TRACK_FILE"
        log "Workspace $workspace_id → nouveau wallpaper : $wallpaper"
    else
        log "Workspace $workspace_id → wallpaper existant : $wallpaper"
    fi

    # Précharge et applique sur tous les moniteurs
    hyprctl hyprpaper preload "$wallpaper"
    monitors=$(hyprctl monitors -j | jq -r '.[].name')
    for m in $monitors; do
        hyprctl hyprpaper wallpaper "$m","$wallpaper"
        log "Wallpaper appliqué sur $m"
    done
}

log "Script lancé, attente des changements de workspace..."

socat -u UNIX-CONNECT:"/run/user/$UID/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    if [[ "$line" =~ ^workspace\>\>([0-9]+) ]]; then
        workspace_id="${BASH_REMATCH[1]}"
        log "Changement vers workspace $workspace_id"
        set_workspace_wallpaper "$workspace_id"
    fi
done

