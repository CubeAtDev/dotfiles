#!/bin/bash

# Script de gestion Bluetooth pour Eww
# Utilise bluetoothctl

get_bluetooth_status() {
    local status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    local devices="[]"

    if [ "$status" = "yes" ]; then
        # Liste des appareils connectés
        local connected=$(bluetoothctl devices Connected 2>/dev/null | awk '{$1=$2=""; print substr($0,3)}')

        if [ -n "$connected" ]; then
            devices="["
            while IFS= read -r device; do
                devices+="{\"name\": \"$device\"},"
            done <<< "$connected"
            devices="${devices%,}]"
        fi

        echo "{\"status\": \"on\", \"devices\": $devices}"
    else
        echo "{\"status\": \"off\", \"devices\": []}"
    fi
}

toggle_bluetooth() {
    local current=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

    if [ "$current" = "yes" ]; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi

    sleep 0.5
    get_bluetooth_status
}

listen_bluetooth() {
    # Écoute les changements Bluetooth
    dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties'" 2>/dev/null | while read -r line; do
        if echo "$line" | grep -q "org.bluez"; then
            get_bluetooth_status
        fi
    done
}

case "$1" in
    --get)
        get_bluetooth_status
        ;;
    --toggle)
        toggle_bluetooth
        ;;
    --listen)
        # Affiche la valeur initiale
        get_bluetooth_status
        # Puis écoute les changements
        listen_bluetooth
        ;;
    *)
        echo "Usage: $0 {--get|--toggle|--listen}"
        exit 1
        ;;
esac
