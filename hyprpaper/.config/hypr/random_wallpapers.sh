#!/usr/bin/env bash

# --- CONFIGURATION ---
WALL_DIR="$HOME/.config/Wallpapers"
TRACK_FILE="/tmp/hypr_visited_workspaces.txt"
SOCKET_PATH="/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"

# --- INITIALISATION ---
[ ! -f "$TRACK_FILE" ] && touch "$TRACK_FILE"

# --- FONCTION : appliquer un wallpaper aléatoire ---
set_random_wallpaper() {
    local workspace_id="$1"
    local wallpaper
    wallpaper=$(find "$WALL_DIR" -type f | shuf -n1)

    # Précharge et applique le fond
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper ,"$wallpaper"

    # Ajoute le workspace à la liste
    echo "$workspace_id" >> "$TRACK_FILE"

    echo "[HyprWallpaper] Nouveau fond d'écran pour workspace $workspace_id : $wallpaper"
}

# --- BOUCLE PRINCIPALE ---
socat -u UNIX-CONNECT:"$SOCKET_PATH" - | while read -r line; do
    if [[ "$line" =~ ^workspace\>\>([0-9]+) ]]; then
        workspace_id="${BASH_REMATCH[1]}"

        # Vérifie si le workspace a déjà été visité
        if ! grep -q "^$workspace_id$" "$TRACK_FILE"; then
            set_random_wallpaper "$workspace_id"
        fi
    fi
done

