#!/bin/bash

# Script de gestion WiFi pour Eww
# Utilise nmcli (NetworkManager)

get_wifi_status() {
    local status=$(nmcli -t -f WIFI g)
    local ssid=""
    local strength=0

    if [ "$status" = "enabled" ]; then
        # Vérifie si connecté
        local connection=$(nmcli -t -f GENERAL.STATE c show --active | grep -q activated && echo "connected" || echo "disconnected")

        if [ "$connection" = "connected" ]; then
            ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
            strength=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2)
        fi

        echo "{\"status\": \"$connection\", \"ssid\": \"$ssid\", \"strength\": $strength}"
    else
        echo "{\"status\": \"disabled\", \"ssid\": \"\", \"strength\": 0}"
    fi
}

toggle_wifi() {
    local current=$(nmcli -t -f WIFI g)

    if [ "$current" = "enabled" ]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi

    get_wifi_status
}

listen_wifi() {
    # Écoute les changements de connexion
    nmcli monitor | while read -r line; do
        get_wifi_status
    done
}

case "$1" in
    --get)
        get_wifi_status
        ;;
    --toggle)
        toggle_wifi
        ;;
    --listen)
        # Affiche la valeur initiale
        get_wifi_status
        # Puis écoute les changements
        listen_wifi
        ;;
    *)
        echo "Usage: $0 {--get|--toggle|--listen}"
        exit 1
        ;;
esac
