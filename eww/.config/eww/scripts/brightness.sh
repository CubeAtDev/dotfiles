#!/bin/bash

# Script de gestion de la luminosité pour Eww
# Utilise brightnessctl (installer avec: sudo pacman -S brightnessctl)

get_brightness() {
    # Récupère la luminosité en pourcentage
    brightnessctl get | awk -v max="$(brightnessctl max)" '{printf "%.0f", ($1/max)*100}'
}

set_brightness() {
    brightnessctl set "$1%"
}

listen_brightness() {
    # Surveille les changements de luminosité
    inotifywait -m -e modify /sys/class/backlight/*/brightness 2>/dev/null | while read -r; do
        get_brightness
    done
}

case "$1" in
    --get)
        get_brightness
        ;;
    --set)
        set_brightness "$2"
        ;;
    --listen)
        # Affiche la valeur initiale
        get_brightness
        # Puis écoute les changements
        listen_brightness
        ;;
    *)
        echo "Usage: $0 {--get|--set VALUE|--listen}"
        exit 1
        ;;
esac
