#!/bin/bash

# Script pour toggle le panel système Eww

# Vérifie si le panel est ouvert
if eww active-windows | grep -q "system-panel"; then
    # Ferme tous les panels
    eww close system-panel
    eww close wifi-panel
    eww close bluetooth-panel
else
    # Ouvre le panel système
    eww open system-panel
fi
