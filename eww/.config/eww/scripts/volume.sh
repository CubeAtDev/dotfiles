#!/bin/bash

# Script de gestion du volume pour Eww
# Utilise pamixer (installer avec: sudo pacman -S pamixer)

get_volume() {
    pamixer --get-volume
}

set_volume() {
    pamixer --set-volume "$1"
}

listen_volume() {
    # Écoute les changements de volume
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "sink"; then
            get_volume
        fi
    done
}

case "$1" in
    --get)
        get_volume
        ;;
    --set)
        set_volume "$2"
        ;;
    --listen)
        # Affiche la valeur initiale
        get_volume
        # Puis écoute les changements
        listen_volume
        ;;
    *)
        echo "Usage: $0 {--get|--set VALUE|--listen}"
        exit 1
        ;;
esac
